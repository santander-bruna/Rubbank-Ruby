class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :cpf
      t.string :name
      t.string :email
      t.string :phone
      t.date :birthdate
      t.string :app_password

      t.timestamps
    end
  end
end
