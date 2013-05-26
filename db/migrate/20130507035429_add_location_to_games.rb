class AddLocationToGames < ActiveRecord::Migration
  def change
    add_column :games, :location_id, :int
  end
end
