# frozen_string_literal: true
# == Schema Information
#
# Table name: payment_intentions
#
#  id           :bigint(8)        not null, primary key
#  code         :string           not null
#  reference    :string           not null
#  category     :string           default("stripe"), not null
#  payable_type :string
#  payable_id   :bigint(8)
#  metadata     :jsonb            not null
#  status       :integer          default("pending")
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
