class AddTiesToTeamSpot < ActiveRecord::Migration
  def change
    add_column :team_spots, :ties, :integer
  end
end
