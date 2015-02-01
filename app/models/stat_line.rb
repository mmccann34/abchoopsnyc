class StatLine < ActiveRecord::Base
  attr_accessible :season_id, :game_id, :player_id, :team_id, :fgm, :fga, :twom, :twoa, :threem, :threea, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :fl, :to, :dnp, :jersey_number, :double_double
  validates :game_id, :player_id, :team_id, presence: true

  belongs_to :player
  belongs_to :game
  belongs_to :season
  belongs_to :team
  belongs_to :vs_team, class_name: "Team"

  after_initialize :set_defaults

  def set_defaults
    if self.has_attribute?(:points)
      self.points ||= 0 
      self.fgm ||= 0 #field goals made
      self.fga ||= 0 #field goals attempted
      self.twom ||= 0 #twos made
      self.twoa ||= 0 #twos attempted
      self.threem ||= 0 #threes made
      self.threea ||= 0 #threes attempted
      self.ftm ||= 0 #free throws made
      self.fta ||= 0 #free throws attempted
      self.orb ||= 0 #offensive rebound
      self.drb ||= 0 #defeinsive rebound
      self.trb ||= 0 #total rebound
      self.ast ||= 0 #assist
      self.stl ||= 0 #steals
      self.blk ||= 0 #block
      self.fl ||= 0 #fouls
      self.to ||= 0 #
    end
  end

  before_save do
#    set_defaults    
    calc_percentages

    self.double_double = [points, trb, ast, stl, blk].select{|s| s >= 10}.count >= 2
    
    if self.game
      self.season_id = self.game.season_id
      self.vs_team_id = self.team_id == self.game.home_team_id ? self.game.away_team_id : self.game.home_team_id
    end
    
    nil
  end

  def calc_percentages
    self.fgm = twom + threem
    self.fga = twoa + threea
    self.fgpct = fga != 0 ? fgm / fga : 0
    self.twopct = twoa != 0 ? twom / twoa : 0
    self.threepct = threea != 0 ? threem / threea : 0
    self.ftpct = fta != 0 ? ftm / fta : 0
    self.trb = orb + drb
    self.points = (twom * 2) + (threem * 3) + (ftm * 1)
  end

  def weighted_stats
    weighted_stats ||= {}
    weighted_stats[:Rebounds] = (self.trb * 0.12)
    weighted_stats[:Assists] = (self.ast * 0.27)
    weighted_stats[:Steals] = (self.stl * 0.17)
    weighted_stats[:Blocks] = (self.blk * 0.34)
    return weighted_stats
  end
end 