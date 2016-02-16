class UpdatePitcherIdNameInMatches < ActiveRecord::Migration
  def change
    rename_column :matches, :pitcher_id_id, :pitcher_id
  end
end
