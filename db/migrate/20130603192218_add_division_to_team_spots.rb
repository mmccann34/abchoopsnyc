class AddDivisionToTeamSpots < ActiveRecord::Migration
  def change
    add_column :team_spots, :division_id, :integer
  end
end
