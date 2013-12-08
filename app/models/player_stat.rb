class PlayerStat < ActiveRecord::Base
  attr_accessible :game_count, :split_name, :points, :season_id, :season_number, :player_id, :team_id, :fgm, :fga, :fgpct, :twom, :twoa, :twopct, :threem, :threea, :threepct, :ftm, :fta, :ftpct, :orb, :drb, :trb, :ast, :stl, :blk, :fl, :to
  
  belongs_to :team
  belongs_to :player
end
