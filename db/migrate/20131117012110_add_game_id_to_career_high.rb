class AddGameIdToCareerHigh < ActiveRecord::Migration
  def change
    add_column :career_highs, :game_id, :integer
  end
end
