class Season < ActiveRecord::Base
  attr_accessible :key, :name, :number
  validates :name, presence: true

  has_many :games
  has_many :team_spots
  has_many :teams, through: :team_spots
  has_many :divisions
  has_many :roster_spots

  def self.current
    Season.find_by_current(true)
  end
  
  def calc_stats
    self.team_spots.each do |ts|
      ts.team.calc_stats(self)
    end
    
    self.roster_spots.each do |rs|
      rs.player.calc_season_stats(self)
    end
  end
  
  def played_games
    self.games.where("winner is not null")
  end
end