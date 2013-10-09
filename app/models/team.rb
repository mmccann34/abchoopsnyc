class Team < ActiveRecord::Base
  attr_accessible :name, :abbreviation
  validates :name, presence: true

  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_team_id'
  has_many :roster_spots, dependent: :destroy
  has_many :team_spots, dependent: :destroy
  has_many :stat_lines
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
  
  def season_count
    self.team_spots.count("DISTINCT season_id").en.ordinate
  end
  
  def per_game_stats(season = nil)
    season_id = season ? season.id : Season.current.id
    StatLine.find_by_sql('SELECT AVG(fgm) as fgm, AVG(fga) as fga, AVG(coalesce(fgm/nullif(fga, 0), 0)) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(coalesce(twom/nullif(twoa, 0), 0)) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(coalesce(threem/nullif(threea, 0), 0)) as threepct,' \
                        'AVG(ftm) as ftm, AVG(fta) as fta, AVG(coalesce(ftm/nullif(fta, 0), 0)) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
                        'AVG(points) as points FROM (SELECT SUM(fgm) as fgm, SUM(fga) as fga, SUM(twom) as twom, SUM(twoa) as twoa, SUM(threem) as threem, SUM(threea) as threea,' \
                        'SUM(ftm) as ftm, SUM(fta) as fta, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
                        "SUM(points) as points FROM stat_lines sl INNER JOIN games g ON sl.game_id = g.id " \
        "WHERE (g.forfeit is null or not g.forfeit) AND (sl.dnp is null OR not sl.dnp) AND team_id = #{self.id} AND g.season_id = #{season_id} GROUP BY game_id) sums").first
  end
  
  def per_game_player_stats(season_id = nil)
    player_stats = Hash.new
    StatLine.select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                    'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
                    'AVG(points) as points, player_id').where(team_id: self.id).where("dnp is null OR not dnp").joins(:game).where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season_id ? season_id : Season.current).group(:player_id).each do |averages|
      player_stats[averages.player_id] = averages
    end
    player_stats
  end
  
  def cumulative_player_stats(season_id = nil)
    player_stats = Hash.new
    StatLine.select('SUM(fgm) as fgm, SUM(fga) as fga, SUM(twom) as twom, SUM(twoa) as twoa, SUM(threem) as threem, SUM(threea) as threea,' \
                    'SUM(ftm) as ftm, SUM(fta) as fta, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
                    'SUM(points) as points, player_id').where(team_id: self.id).where("dnp is null OR not dnp").joins(:game).where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season_id ? season_id : Season.current).group(:player_id).each do |totals|
      totals.calc_percentages
      player_stats[totals.player_id] = totals
    end
    player_stats
  end
  
  def season_totals(season)
    StatLine.joins(:game).select('SUM(fgm) as fgm, SUM(fga) as fga, SUM(twom) as twom, SUM(twoa) as twoa, SUM(threem) as threem, SUM(threea) as threea,' \
                    'SUM(ftm) as ftm, SUM(fta) as fta, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
                    'SUM(points) as points').where(team_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season).first
  end
  
  def abc_plus_win_pct(season)
    self.games(season).pluck("sum(case when home_team_id = #{self.id} then home_score else away_score end) / sum(home_score + away_score + 0.0)").first.to_f
  end
  
  def total_rebounds(season)
    self.stat_lines.joins(:game).where("games.season_id" => season).pluck("sum(trb)").first.to_f
  end
end