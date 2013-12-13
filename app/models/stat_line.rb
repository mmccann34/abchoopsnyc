class StatLine < ActiveRecord::Base
  attr_accessible :season_id, :game_id, :player_id, :team_id, :fgm, :fga, :twom, :twoa, :threem, :threea, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :fl, :to, :dnp, :jersey_number, :double_double
  validates :game_id, :player_id, :team_id, presence: true

  belongs_to :player
  belongs_to :game
  belongs_to :season
  belongs_to :team

  after_initialize :set_defaults
  before_save { self.season_id = self.game.season_id if self.game }

  def set_defaults
    self.points ||= 0
    self.fgm ||= 0
    self.fga ||= 0
    self.twom ||= 0
    self.twoa ||= 0
    self.threem ||= 0
    self.threea ||= 0
    self.ftm ||= 0
    self.fta ||= 0
    self.orb ||= 0
    self.drb ||= 0
    self.trb ||= 0
    self.ast ||= 0
    self.stl ||= 0
    self.blk ||= 0
    self.fl ||= 0
    self.to ||= 0
  end

  before_save do
    set_defaults
    self.fgm = twom + threem
    self.fga = twoa + threea
    calc_percentages
  end

  def calc_percentages
    self.fgpct = fga != 0 ? fgm / fga : 0
    self.twopct = twoa != 0 ? twom / twoa : 0
    self.threepct = threea != 0 ? threem / threea : 0
    self.ftpct = fta != 0 ? ftm / fta : 0
    self.trb = orb + drb
    self.points = (twom * 2) + (threem * 3) + (ftm * 1)
    self.double_double = [points, trb, ast, stl, blk].select{|s| s >= 10}.count >= 2
    nil
  end
end 