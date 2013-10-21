class CreateCareerHighs < ActiveRecord::Migration
  def change
    create_table :career_highs do |t|
      t.integer :player_id
      t.string :description
      t.float :value
      t.string :game

      t.timestamps
    end
  end
end
