class ChangeUserLatAndLngToDecimal < ActiveRecord::Migration
  def change
    remove_column :users, :lng
    remove_column :users, :lat
    add_column :users, :lat, :decimal, :precision => 15, :scale => 10, :default => 0.0
    add_column :users, :lng, :decimal, :precision => 15, :scale => 10, :default => 0.0
  end
end
