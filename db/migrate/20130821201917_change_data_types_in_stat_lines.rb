class ChangeDataTypesInStatLines < ActiveRecord::Migration
  def up
    change_column :stat_lines, :fgm, :float
    change_column :stat_lines, :fga, :float
    change_column :stat_lines, :twom, :float
    change_column :stat_lines, :twoa, :float
    change_column :stat_lines, :threem, :float
    change_column :stat_lines, :threea, :float
    change_column :stat_lines, :ftm, :float
    change_column :stat_lines, :fta, :float
    change_column :stat_lines, :orb, :float
    change_column :stat_lines, :drb, :float
    change_column :stat_lines, :trb, :float
    change_column :stat_lines, :ast, :float
    change_column :stat_lines, :stl, :float
    change_column :stat_lines, :blk, :float
    change_column :stat_lines, :fl, :float
    change_column :stat_lines, :to, :float
    change_column :stat_lines, :points, :float
  end

  def down
    change_column :stat_lines, :fgm, :integer
    change_column :stat_lines, :fga, :integer
    change_column :stat_lines, :twom, :integer
    change_column :stat_lines, :twoa, :integer
    change_column :stat_lines, :threem, :integer
    change_column :stat_lines, :threea, :integer
    change_column :stat_lines, :ftm, :integer
    change_column :stat_lines, :fta, :integer
    change_column :stat_lines, :orb, :integer
    change_column :stat_lines, :drb, :integer
    change_column :stat_lines, :trb, :integer
    change_column :stat_lines, :ast, :integer
    change_column :stat_lines, :stl, :integer
    change_column :stat_lines, :blk, :integer
    change_column :stat_lines, :fl, :integer
    change_column :stat_lines, :to, :integer
    change_column :stat_lines, :points, :integer
  end
end