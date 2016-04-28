class AddUrlToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :map_url, :text
  end
end