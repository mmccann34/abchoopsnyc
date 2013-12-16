class AddIndexToPlayerStat < ActiveRecord::Migration
  def change
    add_index :player_stats, [:stat_type, :season_id]
  end
end
