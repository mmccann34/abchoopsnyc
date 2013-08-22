class AddDivisionIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :division_id, :integer
  end
end
