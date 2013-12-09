class AddRecordFieldsToTeamSpot < ActiveRecord::Migration
  def change
    add_column :team_spots, :wins, :integer
    add_column :team_spots, :losses, :integer
    add_column :team_spots, :points_for, :integer
    add_column :team_spots, :points_against, :integer
    add_column :team_spots, :streak, :string
  end
end
