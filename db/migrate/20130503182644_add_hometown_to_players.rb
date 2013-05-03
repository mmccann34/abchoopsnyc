class AddHometownToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :hometown, :string
  end
end
