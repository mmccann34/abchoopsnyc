class PlayerStat < ActiveRecord::Base
  attr_accessible :game_count, :split_name, :points, :season_id, :season_number, :league_id, :player_id, :team_id, :fgm, :fga, :fgpct, :twom, :twoa, :twopct, :threem, :threea, :threepct, :ftm, :fta, :ftpct, :orb, :drb, :trb, :ast, :stl, :blk, :fl, :to, :double_double
  
  belongs_to :team
  belongs_to :player
  
  after_initialize :set_defaults
  
  def set_defaults
    if self.has_attribute?(:points)
      self.points ||= 0
      self.fgm ||= 0
      self.fga ||= 0
      self.fgpct ||= 0
      self.twom ||= 0
      self.twoa ||= 0
      self.twopct ||= 0
      self.threem ||= 0
      self.threea ||= 0
      self.threepct ||= 0
      self.ftm ||= 0
      self.fta ||= 0
      self.ftpct ||= 0
      self.orb ||= 0
      self.drb ||= 0
      self.trb ||= 0
      self.ast ||= 0
      self.stl ||= 0
      self.blk ||= 0
      self.fl ||= 0
      self.to ||= 0
    end
  end
end
