class AddSponsorAndDonationToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :sponsor, :integer, default: 0
    add_column :accounts, :donation_amount, :float, default: 0
  end
end
