class AddLatitudeAndLongitudeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_index :users, [:latitude, :longitude]
  end
end
