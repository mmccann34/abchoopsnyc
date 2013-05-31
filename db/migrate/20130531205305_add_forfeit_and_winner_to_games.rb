class AddForfeitAndWinnerToGames < ActiveRecord::Migration
  def change
    add_column :games, :forfeit, :boolean
    add_column :games, :winner, :integer
  end
end
