class League < ActiveRecord::Base
  attr_accessible :name, :short_name
  
  has_many :team_spots
  
  def teams(season_id = nil)
    self.team_spots.where(season_id: season_id ? season_id : Season.current).map(&:team)
  end
end
