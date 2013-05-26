class AddTwoToStatLines < ActiveRecord::Migration
  def change
    add_column :stat_lines, :twom, :integer
    add_column :stat_lines, :twoa, :integer
    add_column :stat_lines, :twopct, :float
  end
end
