class UpdateStatLineIndexes < ActiveRecord::Migration
  def change
    remove_index :stat_lines, :team_id
    remove_index :stat_lines, :player_id
    
    add_index :stat_lines, [:team_id, :season_id]
    add_index :stat_lines, [:player_id, :season_id]
  end
end
