class AddShortNameToDateRange < ActiveRecord::Migration
  def change
    add_column :date_ranges, :short_name, :string
  end
end
