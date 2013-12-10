class AddStatsIndexes < ActiveRecord::Migration
  def change
    add_index :player_stats, [:player_id, :stat_type, :season_id]
    add_index :stat_lines, :player_id
  end
end
