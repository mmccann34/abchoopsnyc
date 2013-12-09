class AddDoubleToStatLine < ActiveRecord::Migration
  def change
    add_column :stat_lines, :double_double, :boolean
  end
end
