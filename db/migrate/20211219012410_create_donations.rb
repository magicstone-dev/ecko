class CreateDonations < ActiveRecord::Migration[6.1]
  def change
    create_table :donations do |t|
      t.references :account, null: false
      t.float :amount, null: false
      
      t.timestamps
    end
  end
end
