class AddLeagueIdToPlayerStat < ActiveRecord::Migration
  def change
    add_column :player_stats, :league_id, :integer
  end
end
