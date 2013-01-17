class Roster < ActiveRecord::Base
  attr_accessible :player_id, :season_id, :team_id

  belongs_to :player
  belongs_to :team
  belongs_to :season
end
