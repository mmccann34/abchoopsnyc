class CreateRosterSpots < ActiveRecord::Migration
  def change
    create_table :roster_spots do |t|
      t.integer :player_id
      t.integer :team_id

      t.timestamps
    end
  end
end
