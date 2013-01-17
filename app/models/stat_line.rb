class StatLine < ActiveRecord::Base
  attr_accessible :game_id, :player_id, :team_id, :fgm, :fga, :threem, :threea, :ftm, :fta, :orb, :drb, :ast, :stl, :blk, :fl, :to
  validates :game_id, :player_id, :team_id, presence: true

  belongs_to :player
  belongs_to :game
  belongs_to :team

  before_save do
    if fgm and fga
      self.fgpct = fgm.to_f/fga
    end

    if threem and threea
      self.threepct = threem.to_f/threea
    end

    if ftm and fta
      self.ftpct = ftm.to_f/fta
    end

    if orb and drb
      self.trb = orb + drb
    end

    if fgm and threem and ftm
      self.points = ((fgm - threem) * 2) + (threem * 3) + (ftm * 1)
    end
  end

  def self.stat_line_totals(stat_lines)
    totals = StatLine.new
    totals = stat_lines.inject do |totals, stat_line|
      totals.threem += stat_line.threem if stat_line.threem
      totals.threea += stat_line.threea if stat_line.threea
      totals
    end
  end
end 