class Team < ActiveRecord::Base
  attr_accessible :name, :abbreviation
  validates :name, presence: true

  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_team_id'
  has_many :roster_spots, dependent: :destroy
  has_many :team_spots, dependent: :destroy
  has_many :stat_lines
  has_many :player_stats
  #has_many :players, through: :roster_spots, order: 'last_name'
  
  def roster(season_id = nil)
    self.roster_spots.find_all_by_season_id(season_id ? season_id : Season.current)
  end
  
  def games(season_id = nil)
    Game.where(season_id: season_id ? season_id : Season.current).where("home_team_id = ? OR away_team_id = ?", self.id, self.id)
  end
  
  def played_games(season)
    self.games(season).where("winner is not null")
  end
  
  def wins(season_id = nil)
    self.games(season_id).where(winner: self.id)
  end
  
  def losses(season_id = nil)
    self.games(season_id).where("winner is not null and winner != ?", self.id)
  end
  
  def record(season_id = nil)
    "#{wins(season_id).count}-#{losses(season_id).count}"
  end
  
  def win_pct(season_id = nil)
    played_games = games(season_id).where("winner IS NOT ?", nil).count.to_f
    played_games == 0 ? 0 : (wins(season_id).count.to_f / played_games)
  end
  
  def update_record(season)
    self.team_spots.where(season_id: season).each do |ts|
      wins, losses, points_for, points_against, streak = 0, 0, 0, 0, 0
      type = nil
      last_type = nil
      self.played_games(season).where(league_id: ts.league_id).order("date").each do |game|
        if game.winner == self.id
          type = "Won"
          wins += 1
        else
          type = "Lost"
          losses += 1
        end
        
        points_for += game.home_team_id == self.id ? game.home_score : game.away_score
        points_against += game.home_team_id == self.id ? game.away_score : game.home_score
        
        streak = (type == last_type ? streak : 0) + 1
        last_type = type
      end
      
      ts.update_attributes({wins: wins, losses: losses, points_for: points_for, points_against: points_against, streak: "#{type} #{streak}"})
    end
  end
  
  def season_count
    self.team_spots.count("DISTINCT season_id").en.ordinate
  end
  
  #could use existing playerstats to create average
  def per_game_stats(season = nil)
    season_id = season ? season.id : Season.current.id
    StatLine.find_by_sql('SELECT AVG(fgm) as fgm, AVG(fga) as fga, AVG(coalesce(fgm/nullif(fga, 0), 0)) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(coalesce(twom/nullif(twoa, 0), 0)) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(coalesce(threem/nullif(threea, 0), 0)) as threepct,' \
                        'AVG(ftm) as ftm, AVG(fta) as fta, AVG(coalesce(ftm/nullif(fta, 0), 0)) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
                        'AVG(points) as points, COUNT(*) as game_count, sums.league_id FROM (SELECT SUM(fgm) as fgm, SUM(fga) as fga, SUM(twom) as twom, SUM(twoa) as twoa, SUM(threem) as threem, SUM(threea) as threea,' \
                        'SUM(ftm) as ftm, SUM(fta) as fta, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
                        "SUM(points) as points, g.league_id as league_id FROM stat_lines sl INNER JOIN games g ON sl.game_id = g.id " \
        "WHERE g.winner is not null AND (g.forfeit is null or not g.forfeit) AND (sl.dnp is null OR not sl.dnp) AND team_id = #{self.id} AND g.season_id = #{season_id} GROUP BY game_id, g.league_id) sums GROUP BY sums.league_id")
  end
  
  def season_totals(season)
    StatLine.joins(:game).select('SUM(fgm) as fgm, SUM(fga) as fga, coalesce(SUM(fgm)/nullif(SUM(fga), 0), 0) as fgpct, SUM(twom) as twom, SUM(twoa) as twoa, coalesce(SUM(twom)/nullif(SUM(twoa), 0), 0) as twopct, SUM(threem) as threem, SUM(threea) as threea, coalesce(SUM(threem)/nullif(SUM(threea), 0), 0) as threepct,' \
                    'SUM(ftm) as ftm, SUM(fta) as fta, coalesce(SUM(ftm)/nullif(SUM(fta), 0), 0) as ftpct, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
                    'SUM(points) as points, games.league_id').where(team_id: self.id).where("games.season_id" => season).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").group("games.league_id")
  end
  
  def abc_plus_win_pct(season)
    self.games(season).pluck("sum(case when home_team_id = #{self.id} then home_score else away_score end) / sum(home_score + away_score + 0.0)").first.to_f rescue 0
  end
  
  def calc_stats(season)
    set_team_stats('team_per_game_average', season, self.per_game_stats(season))
    set_team_stats('team_season_total', season, self.season_totals(season))
    update_record(season)
  end
  
  def recalc_all_stats
    self.team_spots.each do |ts|
      calc_stats(ts.season)
    end
  end
  
  def set_team_stats(stat_type, season, stats)
    stats.each do |s|
      team_stat = self.player_stats.where(stat_type: stat_type).where(season_id: season.id).where(league_id: s.league_id).first_or_initialize
      team_stat.attributes = {points: s.points, fgm: s.fgm, fga: s.fga, fgpct: s.fgpct, twom: s.twom, twoa: s.twoa, twopct: s.twopct, threem: s.threem, threea: s.threea, threepct: s.threepct, ftm: s.ftm, fta: s.fta, ftpct: s.ftpct, orb: s.orb, drb: s.drb, trb: s.trb, ast: s.ast, stl: s.stl, blk: s.blk, fl: s.fl, to: s.to}
      team_stat.save
    end
  end
end