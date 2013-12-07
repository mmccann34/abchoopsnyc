class TeamSpot < ActiveRecord::Base
  attr_accessible :season_id, :team_id, :division_id, :league_id, :team_photo_url
  
  belongs_to :team
  belongs_to :division
  belongs_to :league
  belongs_to :season
end
