class AddDelayedStatCalcFields < ActiveRecord::Migration
  def change
    add_column :players, :needs_to_calc_stats_for_season_id, :integer
    add_column :teams, :needs_to_calc_stats_for_season_id, :integer
  end
end
