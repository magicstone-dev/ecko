# frozen_string_literal: true

# == Schema Information
#
# Table name: account_statuses_cleanup_policies
#
#  id                 :bigint           not null, primary key
#  account_id         :bigint           not null
#  enabled            :boolean          default(TRUE), not null
#  min_status_age     :integer          default(1209600), not null
#  keep_direct        :boolean          default(TRUE), not null
#  keep_pinned        :boolean          default(TRUE), not null
#  keep_polls         :boolean          default(FALSE), not null
#  keep_media         :boolean          default(FALSE), not null
#  keep_self_fav      :boolean          default(TRUE), not null
#  keep_self_bookmark :boolean          default(TRUE), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class AccountStatusesCleanupPolicy < ApplicationRecord
  include Redisable

  ALLOWED_MIN_STATUS_AGE = [2.weeks.seconds, 1.month.seconds, 2.months.seconds, 3.months.seconds, 6.months.seconds, 1.year.seconds, 2.years.seconds].freeze
  EARLY_SEARCH_CUTOFF    = 5000

  belongs_to :account

  validates :min_status_age, inclusion: { in: ALLOWED_MIN_STATUS_AGE }
  validate :validate_local_account

  before_save :update_last_inspected

  def statuses_to_delete(limit = 50, max_id = nil, min_id = nil)
    scope = account.statuses
    scope.merge!(old_enough_scope(max_id))
    scope = scope.where(Status.arel_table[:id].gteq(min_id)) if min_id.present?
    scope.merge!(without_direct_scope) if keep_direct?
    scope.merge!(without_pinned_scope) if keep_pinned?
    scope.merge!(without_poll_scope) if keep_polls?
    scope.merge!(without_media_scope) if keep_media?
    scope.merge!(without_self_fav_scope) if keep_self_fav?
    scope.merge!(without_self_bookmark_scope) if keep_self_bookmark?

    scope.reorder(id: :asc).limit(limit)
  end

  # This computes a toot id such that:
  # - the toot would be old enough to be candidate for deletion
  # - there are at most EARLY_SEARCH_CUTOFF toots between the last inspected toot and this one
  #
  # The idea is to limit expensive SQL queries when an account has lots of toots excluded from
  # deletion, while not starting anew on each run.
  def compute_cutoff_id
    min_id = last_inspected || 0
    max_id = Mastodon::Snowflake.id_at_start(min_status_age.seconds.ago)
    subquery = account.statuses.where(Status.arel_table[:id].gteq(min_id)).where(Status.arel_table[:id].lteq(max_id))
    subquery = subquery.select(:id).reorder(id: :asc).limit(EARLY_SEARCH_CUTOFF)
    Status.connection.execute("SELECT MAX(id) FROM (#{subquery.to_sql}) t").values.first.first
  end

  # The most important thing about `last_inspected` is that any toot older than it is guaranteed
  # not to be kept by the policy regardless of its age.
  def record_last_inspected(last_id)
    redis.set("account_cleanup:#{account.id}", last_id, ex: 3.days.seconds)
  end

  def last_inspected
    redis.get("account_cleanup:#{account.id}")&.to_i
  end

  def invalidate_last_inspected(status, action)
    last_value = last_inspected
    return if last_value.nil? || status.id > last_value || status.account_id != account_id

    case action
    when :unbookmark
      return unless keep_self_bookmark?
    when :unfav
      return unless keep_self_fav?
    when :unpin
      return unless keep_pinned?
    end

    record_last_inspected(status.id)
  end

  private

  def update_last_inspected
    if %w(keep_direct keep_pinned keep_polls keep_media keep_self_fav keep_self_bookmark).map { |name| attribute_change_to_be_saved(name) }.compact.include?([true, false])
      # Policy has been widened in such a way that any previously-inspected status
      # may need to be deleted, so we'll have to start again.
      redis.del("account_cleanup:#{account.id}")
    end
  end

  def validate_local_account
    errors.add(:account, :invalid) unless account&.local?
  end

  def without_direct_scope
    Status.where.not(visibility: :direct)
  end

  def old_enough_scope(max_id = nil)
    # Filtering on `id` rather than `min_status_age` ago will treat
    # non-snowflake statuses as older than they really are, but Mastodon
    # has switched to snowflake IDs significantly over 2 years ago anyway.
    max_id = [max_id, Mastodon::Snowflake.id_at_start(min_status_age.seconds.ago)].compact.min
    Status.where(Status.arel_table[:id].lteq(max_id))
  end

  def without_self_fav_scope
    Status.where('NOT EXISTS (SELECT * FROM favourites fav WHERE fav.account_id = statuses.account_id AND fav.status_id = statuses.id)')
  end

  def without_self_bookmark_scope
    Status.where('NOT EXISTS (SELECT * FROM bookmarks bookmark WHERE bookmark.account_id = statuses.account_id AND bookmark.status_id = statuses.id)')
  end

  def without_pinned_scope
    Status.where('NOT EXISTS (SELECT * FROM status_pins pin WHERE pin.account_id = statuses.account_id AND pin.status_id = statuses.id)')
  end

  def without_media_scope
    Status.where('NOT EXISTS (SELECT * FROM media_attachments media WHERE media.status_id = statuses.id)')
  end

  def without_poll_scope
    Status.where(poll_id: nil)
  end
end
