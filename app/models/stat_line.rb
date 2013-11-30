class StatLine < ActiveRecord::Base
  attr_accessible :game_id, :player_id, :team_id, :fgm, :fga, :twom, :twoa, :threem, :threea, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :fl, :to, :dnp, :jersey_number
  validates :game_id, :player_id, :team_id, presence: true

  belongs_to :player
  belongs_to :game
  belongs_to :team

  after_initialize :set_defaults
#  after_save { self.player.calc_stats }

  def set_defaults
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
  end
end 