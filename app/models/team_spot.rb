class TeamSpot < ActiveRecord::Base
  attr_accessible :season_id, :team_id, :division_id, :league_id, :team_photo_url, :wins, :losses, :points_for, :points_against, :streak
  
  belongs_to :team
  belongs_to :division
  belongs_to :league
  belongs_to :season
  
  after_initialize :set_defaults
  
  def set_defaults
    self.wins ||= 0
    self.losses ||= 0
    self.points_for ||= 0
    self.points_against ||= 0
  end
  
  def win_pct
    games_played = self.wins + self.losses
    games_played == 0 ? 0 : self.wins.to_f / games_played.to_f
  end
  
  def record
    "#{self.wins}-#{self.losses}"
  end
  
  def point_diff
    self.points_for - self.points_against
  end
end
