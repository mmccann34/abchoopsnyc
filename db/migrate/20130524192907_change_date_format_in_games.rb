class ChangeDateFormatInGames < ActiveRecord::Migration
  def up 
    change_column :games, :date, :datetime
  end

  def down
    change_column :games, :date, :date
  end
end
