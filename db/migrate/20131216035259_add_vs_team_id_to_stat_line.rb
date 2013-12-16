class AddVsTeamIdToStatLine < ActiveRecord::Migration
  def change
    add_column :stat_lines, :vs_team_id, :integer
  end
end
