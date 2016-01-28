class AddMatchAndMatchTimeToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :match, :boolean, default: false
    add_column :likes, :match_time, :datetime
  end
end
