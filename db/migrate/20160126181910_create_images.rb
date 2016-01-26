class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user_id
      t.string :img_src
      t.integer :position
      t.boolean :main_image?
      t.boolean :flagged?

      t.timestamps null: false
    end
  end
end
