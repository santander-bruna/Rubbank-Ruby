class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :num_account
      t.string :agency
      t.string :status
      t.decimal :balance
      t.string :password
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
