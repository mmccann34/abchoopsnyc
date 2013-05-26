class AddOtToGames < ActiveRecord::Migration
  def change
    add_column :games, :home_score_ot_one, :integer
    add_column :games, :home_score_ot_two, :integer
    add_column :games, :home_score_ot_three, :integer
    add_column :games, :away_score_ot_one, :integer
    add_column :games, :away_score_ot_two, :integer
    add_column :games, :away_score_ot_three, :integer
  end
end
