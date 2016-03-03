class ChangeSeenCountOnLikes < ActiveRecord::Migration
  def change
    remove_column :likes, :seen_count
    add_column :likes, :likee_seen_count, :integer, default: 0
  end
end
