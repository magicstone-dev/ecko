class AddSponsorAndDonationToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :sponsor, :integer
    change_column_default :accounts, :sponsor, 0
    add_column :accounts, :donation_amount, :float
    change_column_default :accounts, :donation_amount, 0
  end
end
