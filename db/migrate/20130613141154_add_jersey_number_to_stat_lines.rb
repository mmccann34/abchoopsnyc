class AddJerseyNumberToStatLines < ActiveRecord::Migration
  def change
    add_column :stat_lines, :jersey_number, :integer
  end
end
