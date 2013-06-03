class CreateTeamSpots < ActiveRecord::Migration
  def change
    create_table :team_spots do |t|
      t.integer :team_id
      t.integer :season_id

      t.timestamps
    end
  end
end
