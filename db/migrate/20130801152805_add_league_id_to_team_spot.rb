class AddLeagueIdToTeamSpot < ActiveRecord::Migration
  def change
    add_column :team_spots, :league_id, :integer
  end
end
