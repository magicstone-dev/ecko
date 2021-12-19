class CreateDonationPackages < ActiveRecord::Migration[6.1]
  def change
    create_table :donation_packages do |t|
      t.float :amount
      t.integer :currency
      t.string :title
      t.text :description
      t.integer :donation_reference, default: 0
      t.boolean :visible, default: true

      t.timestamps
    end
  end
end
