class AddIndexToGames < ActiveRecord::Migration
  def change
    add_index :games, :season_id
  end
end
