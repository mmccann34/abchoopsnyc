class AddTeamIdToTopPerformers < ActiveRecord::Migration
  def change
  	add_column :top_performers, :team_id, :integer
  end
end
