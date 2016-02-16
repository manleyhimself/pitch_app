class AddAttributesToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :user_1_seen, :boolean
    add_column :matches, :user_2_seen, :boolean
    add_reference :matches, :pitcher_id, index: true, foreign_key: true
    add_column :matches, :pitch_seen, :boolean
    add_column :matches, :locked, :boolean
  end
end
