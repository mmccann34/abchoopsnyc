class AddSeasonToRosterSpots < ActiveRecord::Migration
  def change
    add_column :roster_spots, :season_id, :integer
  end
end
