class CreateAbcPlusScores < ActiveRecord::Migration
  def change
    create_table :abc_plus_scores do |t|
      t.integer :player_id
      t.integer :season_id
      t.float :score

      t.timestamps
    end
  end
end
