class AddIndexesToUserForeignKeys < ActiveRecord::Migration
  def change
    add_index :images, :user_id

    add_index :likes, :user_id
    add_index :likes, :likee_id
    
    add_index :matches, :user_1_id
    add_index :matches, :user_2_id
  end
end
