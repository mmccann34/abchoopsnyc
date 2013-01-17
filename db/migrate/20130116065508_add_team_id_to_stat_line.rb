class AddTeamIdToStatLine < ActiveRecord::Migration
  def change
    add_column :stat_lines, :team_id, :integer
  end
end
