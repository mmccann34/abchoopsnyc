class AddDoubleToPlayerStat < ActiveRecord::Migration
  def change
    add_column :player_stats, :double_double, :integer
  end
end
