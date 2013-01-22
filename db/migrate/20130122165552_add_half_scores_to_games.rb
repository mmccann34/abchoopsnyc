class AddHalfScoresToGames < ActiveRecord::Migration
  def change
    add_column :games, :home_score_first, :integer
    add_column :games, :home_score_second, :integer
    add_column :games, :away_score_first, :integer
    add_column :games, :away_score_second, :integer
  end
end