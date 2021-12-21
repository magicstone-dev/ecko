# frozen_string_literal: true
# == Schema Information
#
# Table name: donations
#
#  id         :bigint(8)        not null, primary key
#  account_id :bigint(8)        not null
#  amount     :float            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Donation < ApplicationRecord
  belongs_to :account, inverse_of: :donations
end
