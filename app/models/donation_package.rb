# == Schema Information
#
# Table name: donation_packages
#
#  id                 :bigint(8)        not null, primary key
#  amount             :float
#  currency           :integer
#  title              :string
#  description        :text
#  donation_reference :integer          default(0)
#  visible            :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class DonationPackage < ApplicationRecord
  scope :visible, -> { where(visible: true) }
end
