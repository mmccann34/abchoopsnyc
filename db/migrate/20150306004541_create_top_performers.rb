class CreateTopPerformers < ActiveRecord::Migration
  def change
    create_table :top_performers do |t|
      t.integer :game_id
      t.integer :player_id
      t.string :name
      t.string :team
      t.string :stat
      t.integer :performer_type

      t.timestamps
    end
    
    add_index :top_performers, :game_id
  end
end
