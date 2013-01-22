class StatLine < ActiveRecord::Base
  attr_accessible :game_id, :player_id, :team_id, :fgm, :fga, :threem, :threea, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :fl, :to
  validates :game_id, :player_id, :team_id, presence: true

  belongs_to :player
  belongs_to :game
  belongs_to :team

  after_initialize :set_defaults

  def set_defaults
    self.fgm ||= 0
    self.fga ||= 0
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
    calc_percentages
  end

  def calc_percentages
    self.fgpct = fgm.to_f/fga unless fga == 0
    self.threepct = threem.to_f/threea unless threea == 0
    self.ftpct = ftm.to_f/fta unless fta == 0
    self.trb = orb + drb
    self.points = ((fgm - threem) * 2) + (threem * 3) + (ftm * 1)
  end
end 