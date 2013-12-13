class AddSeasonIdToStatLines < ActiveRecord::Migration
  def change
    add_column :stat_lines, :season_id, :integer
  end
end
