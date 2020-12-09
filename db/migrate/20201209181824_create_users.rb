class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.string :fullname, null: false
      t.datetime :birthday, null: false
      t.string :email, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.string :zip, null: false
      t.integer :role, null: false

      t.timestamps
    end
  end
end
