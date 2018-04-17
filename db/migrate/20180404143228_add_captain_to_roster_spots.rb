class AddCaptainToRosterSpots < ActiveRecord::Migration
  def change
    add_column :roster_spots, :captain, :boolean, :default => false
  end
end