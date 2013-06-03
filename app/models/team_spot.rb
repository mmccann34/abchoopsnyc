class TeamSpot < ActiveRecord::Base
  attr_accessible :season_id, :team_id
  
  belongs_to :team
end
