class AddSeasonNumberToPlayerStat < ActiveRecord::Migration
  def change
    add_column :player_stats, :season_number, :integer
  end
end
