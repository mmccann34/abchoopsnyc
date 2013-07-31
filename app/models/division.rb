class Division < ActiveRecord::Base
  attr_accessible :name, :season_id
  
  has_many :team_spots
  has_many :teams, through: :team_spots
end
