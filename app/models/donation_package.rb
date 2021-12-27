# == Schema Information
#
# Table name: donation_packages
#
#  id                 :bigint(8)        not null, primary key
#  amount             :float
#  currency           :integer
#  title              :string
#  description        :text
#  donation_reference :integer          default("free_tier")
#  visible            :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class DonationPackage < ApplicationRecord
  scope :visible, -> { where(visible: true) }
  enum donation_reference: {
    free_tier: 0,
    silver_tier: 100,
    gold_tier: 1000,
    platinum_tier: 2000,
  }
  enum currency: {
    usd: 0,
    eur: 1,
  }
end
