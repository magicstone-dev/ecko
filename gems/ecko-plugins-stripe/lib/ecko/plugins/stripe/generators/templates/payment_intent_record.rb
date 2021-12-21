# frozen_string_literal: true
# == Schema Information
#
# Table name: account_identity_proofs
#
#  id                :bigint(8)        not null, primary key
#  code              :string           not null, Unique code for intension, SecureRanodm uuid
#  provider          :string           default(""), not null
#  provider_username :string           default(""), not null
#  token             :text             default(""), not null
#  verified          :boolean          default(FALSE), not null
#  live              :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class StripePaymentIntent < ApplicationRecord
  self.table_name = 'payment_intentions'
  before_create :set_code

  enum status: {
    pending: 0,
    closed: 0,
  }

  belongs_to :payable, polymorphic: true

  def set_code
    self.code = SecureRandom.uuid
  end
end
