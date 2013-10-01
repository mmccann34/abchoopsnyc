class ChangeAboutColumnTypeInPlayers < ActiveRecord::Migration
  def self.up
    change_column :players, :about, :text
  end

  def self.down
    change_column :players, :about, :string
  end
end
