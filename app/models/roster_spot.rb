class RosterSpot < ActiveRecord::Base
  attr_accessible :player_id, :team_id, :season_id, :jersey_number, :captain

  belongs_to :player
  belongs_to :team
  belongs_to :season
  
  after_save { self.player.update_roster_info }
end
