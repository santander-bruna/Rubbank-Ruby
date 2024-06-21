class CreateTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :transfers do |t|
      t.integer :beneficiary_id
      t.integer :payer_id
      t.string :description
      t.decimal :amount
      t.datetime :date

      t.timestamps
    end
  end
end
