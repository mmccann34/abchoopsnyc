class CreatePlayerStats < ActiveRecord::Migration
  def change
    create_table :player_stats do |t|
      t.integer  :player_id
      t.integer  :season_id
      t.float    :points
      t.integer  :team_id
      t.float    :fgm
      t.float    :fga
      t.float    :fgpct
      t.float    :threem
      t.float    :threea
      t.float    :threepct
      t.float    :ftm
      t.float    :fta
      t.float    :ftpct
      t.float    :orb
      t.float    :drb
      t.float    :trb
      t.float    :ast
      t.float    :stl
      t.float    :blk
      t.float    :fl
      t.float    :to
      t.float    :twom
      t.float    :twoa
      t.float    :twopct
      t.string   :stat_type
      t.integer  :game_count
      t.string   :split_name
      t.timestamps
    end
  end
end
