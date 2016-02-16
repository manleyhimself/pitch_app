class AddDefaultsToMatches < ActiveRecord::Migration
  def change
    change_column :matches, :user_1_seen, :boolean, default: false
    change_column :matches, :user_2_seen, :boolean, default: false
    change_column :matches, :pitch_seen, :boolean, default: false
    change_column :matches, :locked, :boolean, default: true
  end
end
