class Team < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true

  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_team_id'
  has_many :roster_spots, dependent: :destroy
  has_many :team_spots, dependent: :destroy
  #has_many :players, through: :roster_spots, order: 'last_name'
  
  def roster(season_id = nil)
    self.roster_spots.find_all_by_season_id(season_id ? season_id : Season.current)
  end
end