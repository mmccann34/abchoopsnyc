class AddDnpToStatLines < ActiveRecord::Migration
  def change
    add_column :stat_lines, :dnp, :boolean
  end
end
