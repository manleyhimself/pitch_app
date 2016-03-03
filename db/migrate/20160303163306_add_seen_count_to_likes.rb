class AddSeenCountToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :seen_count, :integer
  end
end
