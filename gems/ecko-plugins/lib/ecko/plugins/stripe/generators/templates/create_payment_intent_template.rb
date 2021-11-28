# frozen_string_literal: true

class CreatePayableIntent < ActiveRecord::Migration[6.1]
  def change
    create_table(:payment_intentions, force: false) do |t|
      t.string :code, null: false
      t.string :reference, null: false
      t.string :category, null: false, default: 'stripe'
      t.references :payable, polymorphic: true
      t.jsonb :metadata, null: false
    end
    add_index :payment_intentions, [:code], unique: true
    add_index :payment_intentions, [:category]
  end
end
