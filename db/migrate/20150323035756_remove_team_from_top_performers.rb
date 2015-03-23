class RemoveTeamFromTopPerformers < ActiveRecord::Migration
  def up
    remove_column :top_performers, :team
  end

  def down
    add_column :top_performers, :team, :string
  end
end
