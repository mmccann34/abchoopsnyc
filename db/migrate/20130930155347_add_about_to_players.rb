class AddAboutToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :about, :string
    add_column :players, :day_job, :string
  end
end
