class AddPlayoffRoundToGame < ActiveRecord::Migration
  def change
    add_column :games, :playoff_round, :string
  end
end
