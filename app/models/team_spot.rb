class TeamSpot < ActiveRecord::Base
  attr_accessible :season_id, :team_id
  
  belongs_to :team
  belongs_to :division
end
