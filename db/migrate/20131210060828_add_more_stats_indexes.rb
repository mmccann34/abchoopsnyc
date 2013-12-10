class AddMoreStatsIndexes < ActiveRecord::Migration
  def change
    add_index :team_spots, :team_id
    add_index :team_spots, :season_id
    add_index :stat_lines, :team_id
    add_index :player_stats, [:team_id, :stat_type, :season_id]
    add_index :career_highs, [:player_id]
  end
end
