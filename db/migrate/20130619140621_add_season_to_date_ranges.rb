class AddSeasonToDateRanges < ActiveRecord::Migration
  def change
    add_column :date_ranges, :season_id, :integer
  end
end
