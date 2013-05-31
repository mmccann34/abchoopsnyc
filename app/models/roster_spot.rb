class RosterSpot < ActiveRecord::Base
  attr_accessible :player_id, :team_id, :season_id

  belongs_to :player
  belongs_to :team
  belongs_to :season
end
