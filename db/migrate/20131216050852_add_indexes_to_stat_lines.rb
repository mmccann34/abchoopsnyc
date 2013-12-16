class AddIndexesToStatLines < ActiveRecord::Migration
  def change
    add_index :stat_lines, :points
    add_index :stat_lines, :trb
    add_index :stat_lines, :ast
    add_index :stat_lines, :blk
    add_index :stat_lines, :stl
    add_index :stat_lines, :fgm
    add_index :stat_lines, :threem
    add_index :stat_lines, :ftm
  end
end
