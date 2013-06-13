class AddJerseyNumberToRosterSpots < ActiveRecord::Migration
  def change
    add_column :roster_spots, :jersey_number, :integer
  end
end
