class AddGameIdIndexToStatLine < ActiveRecord::Migration
  def change
    add_index :stat_lines, :game_id
  end
end
