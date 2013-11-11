class AddLeagueToDateRange < ActiveRecord::Migration
  def change
    add_column :date_ranges, :league_id, :integer
  end
end
