class AddStatsToStatLine < ActiveRecord::Migration
  def change
    add_column :stat_lines, :fgm, :integer
    add_column :stat_lines, :fga, :integer
    add_column :stat_lines, :fgpct, :float
    add_column :stat_lines, :twom, :integer
    add_column :stat_lines, :twoa, :integer
    add_column :stat_lines, :twopct, :float
    add_column :stat_lines, :threem, :integer
    add_column :stat_lines, :threea, :integer
    add_column :stat_lines, :threepct, :float
    add_column :stat_lines, :ftm, :integer
    add_column :stat_lines, :fta, :integer
    add_column :stat_lines, :ftpct, :float
    add_column :stat_lines, :orb, :integer
    add_column :stat_lines, :drb, :integer
    add_column :stat_lines, :trb, :integer
    add_column :stat_lines, :ast, :integer
    add_column :stat_lines, :stl, :integer
    add_column :stat_lines, :blk, :integer
    add_column :stat_lines, :fl, :integer
    add_column :stat_lines, :to, :integer
  end
end
