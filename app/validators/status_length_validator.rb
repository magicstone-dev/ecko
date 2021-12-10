# frozen_string_literal: true

class StatusLengthValidator < ActiveModel::Validator
  URL_PLACEHOLDER_CHARS = 23
  URL_PLACEHOLDER = "\1#{'x' * URL_PLACEHOLDER_CHARS}"

  def validate(status)
    return unless status.local? && !status.reblog?

    max_characters = StaticSetting.registry.max_post_character
    @status = status
    status.errors.add(:text, I18n.t('statuses.over_character_limit', max: max_characters)) if too_long?(max_characters)
  end

  private

  def too_long?(max_characters)
    countable_length > max_characters
  end

  def countable_length
    total_text.mb_chars.grapheme_length
  end

  def total_text
    [@status.spoiler_text, countable_text].join
  end

  def countable_text
    return '' if @status.text.nil?

    @status.text.dup.tap do |new_text|
      new_text.gsub!(FetchLinkCardService::URL_PATTERN, URL_PLACEHOLDER)
      new_text.gsub!(Account::MENTION_RE, '@\2')
    end
  end
end
