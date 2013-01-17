class RemoveTwoPointersFromStatLine < ActiveRecord::Migration
  def up
    remove_column :stat_lines, :twom
    remove_column :stat_lines, :twoa
    remove_column :stat_lines, :twopct
  end

  def down
    add_column :stat_lines, :twopct, :float
    add_column :stat_lines, :twoa, :integer
    add_column :stat_lines, :twom, :integer
  end
end
