class AddNumberToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :number, :integer
  end
end
