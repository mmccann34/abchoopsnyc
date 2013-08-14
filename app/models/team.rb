class Team < ActiveRecord::Base
  attr_accessible :name, :abbreviation
  validates :name, presence: true

  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_team_id'
  has_many :roster_spots, dependent: :destroy
  has_many :team_spots, dependent: :destroy
  #has_many :players, through: :roster_spots, order: 'last_name'
  
  def roster(season_id = nil)
    self.roster_spots.find_all_by_season_id(season_id ? season_id : Season.current)
  end
  
  def games(season_id = nil)
    Game.where(season_id: season_id ? season_id : Season.current).where("home_team_id = ? OR away_team_id = ?", self.id, self.id)
  end
  
  def wins(season_id = nil)
    self.games(season_id).where(winner: self.id)
  end
  
  def losses(season_id = nil)
    self.games(season_id).where("winner != ?", self.id)
  end
  
  def record(season_id = nil)
    "#{wins(season_id).count}-#{losses(season_id).count}"
  end
  
  def win_pct(season_id = nil)
    played_games = games(season_id).where("winner IS NOT ?", nil).count.to_f
    played_games == 0 ? 0 : (wins(season_id).count.to_f / games(season_id).where("winner IS NOT ?", nil).count.to_f)
  end
end