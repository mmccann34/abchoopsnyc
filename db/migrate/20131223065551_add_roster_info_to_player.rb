class AddRosterInfoToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :main_team_id, :integer
    add_column :players, :last_number, :integer
  end
end
