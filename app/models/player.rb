class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :key, :height, :weight, :age, :profile_pic, :profile_pic_url, :profile_pic_flickr_url, :team_id, :number, :height_feet, :height_inches, :school, :position, :hometown, :day_job, :about, :birthday
  validate :first_or_last

  has_attached_file :profile_pic, styles: { medium: "300x300#", profile: "200X200#", thumb: "100x100#" }

  has_many :stat_lines
  has_many :roster_spots, dependent: :destroy
  has_many :teams, through: :roster_spots
  has_many :career_highs
  has_many :player_stats
  has_many :abc_plus_scores

  before_validation do
    self.key = key.strip if key
  end

  def name
    "#{first_name} #{last_name}"
  end

  def height
    "#{height_feet}-#{height_inches}"
  end
  
  def calc_age
    self.birthday ? Time.diff(Date.today, self.birthday)[:year] : nil
  end
  
  def last_team
    roster_spots.sort_by{|rs| rs.season_id}[-1].try(:team)
  end
  
  def team_by_season(season)
    roster_spots.where(season_id: season).first.try(:team)
  end
  
  def last_number
    roster_spots.sort_by{|rs| rs.season_id}[-1].try(:jersey_number)
  end
  
  def season_count
    self.roster_spots.count("DISTINCT season_id")
  end
  
  def game_log(season)
    self.stat_lines.where("dnp is null OR not dnp").joins(:game).where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season).order("games.date")
  end
  
  #def per_game_stats(season)
  #  StatLine.find_by_sql('SELECT AVG(fgm) as fgm, AVG(fga) as fga, AVG(coalesce(fgm/nullif(fga, 0), 0)) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(coalesce(twom/nullif(twoa, 0), 0)) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(coalesce(threem/nullif(threea, 0), 0)) as threepct,' \
  #                      'AVG(ftm) as ftm, AVG(fta) as fta, AVG(coalesce(ftm/nullif(fta, 0), 0)) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
  #                      'AVG(points) as points FROM stat_lines sl INNER JOIN games g ON sl.game_id = g.id ' \
  #                      "WHERE (g.forfeit is null or not g.forfeit) AND (sl.dnp is null OR not sl.dnp) AND player_id = #{self.id} AND g.season_id = #{season.id}").first
  #end
  
  def season_averages(season)
    StatLine.joins(:game => :season).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                            'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        'AVG(points) as points, seasons.number as season_number, seasons.id as season_id, team_id, COUNT(*) as game_count').where(player_id: self.id).where("seasons.id" => season).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").group("team_id, seasons.number, seasons.id")
  end
  
  def career_averages
    StatLine.joins(:game).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        'AVG(points) as points, COUNT(*) as game_count').where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").first
  end
  
  def season_totals(season)
    StatLine.joins(:game => :season).select('SUM(fgm) as fgm, SUM(fga) as fga, coalesce(SUM(fgm)/nullif(SUM(fga), 0), 0) as fgpct, SUM(twom) as twom, SUM(twoa) as twoa, coalesce(SUM(twom)/nullif(SUM(twoa), 0), 0) as twopct, SUM(threem) as threem, SUM(threea) as threea, coalesce(SUM(threem)/nullif(SUM(threea), 0), 0) as threepct,' \
                    'SUM(ftm) as ftm, SUM(fta) as fta, coalesce(SUM(ftm)/nullif(SUM(fta), 0), 0) as ftpct, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
        'SUM(points) as points, seasons.number as season_number, seasons.id as season_id, team_id, COUNT(*) as game_count').where(player_id: self.id).where("seasons.id" => season).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").group("team_id, seasons.number, seasons.id")
  end
  
  def average_per_season_totals
    StatLine.find_by_sql('SELECT AVG(fgm) as fgm, AVG(fga) as fga, AVG(coalesce(fgm/nullif(fga, 0), 0)) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(coalesce(twom/nullif(twoa, 0), 0)) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(coalesce(threem/nullif(threea, 0), 0)) as threepct,' \
                        'AVG(ftm) as ftm, AVG(fta) as fta, AVG(coalesce(ftm/nullif(fta, 0), 0)) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        'AVG(points) as points, SUM(game_count) as game_count FROM (SELECT SUM(fgm) as fgm, SUM(fga) as fga, SUM(twom) as twom, SUM(twoa) as twoa, SUM(threem) as threem, SUM(threea) as threea,' \
                        'SUM(ftm) as ftm, SUM(fta) as fta, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
        "SUM(points) as points, COUNT(*) as game_count FROM stat_lines sl INNER JOIN games g ON sl.game_id = g.id " \
                        "WHERE (g.forfeit is null or not g.forfeit) AND (sl.dnp is null OR not sl.dnp) AND player_id = #{self.id} GROUP BY g.season_id) sums").first
  end
  
  #def season_averages(season)
  #  StatLine.joins(:game).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
  #                               'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
  #      'AVG(points) as points, COUNT(*) as games_played').where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").where("games.season_id = #{season.id != -1 ? season.id : "games.season_id"}").first
  #end
  
  #def season_totals(season)
  #  StatLine.joins(:game).select('SUM(fgm) as fgm, SUM(fga) as fga, SUM(twom) as twom, SUM(twoa) as twoa, SUM(threem) as threem, SUM(threea) as threea,' \
  #                  'SUM(ftm) as ftm, SUM(fta) as fta, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
  #                  'SUM(points) as points').where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season).first
  #end
  
  def splits_by_result(season_id)
    StatLine.joins(:game => :season).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        "AVG(points) as points, #{season_id} as season_id, COUNT(*) as game_count, case when games.winner = team_id then 'In wins' else 'In losses' end as split_name").where(player_id: self.id).where("seasons.id = #{season_id != -1 ? season_id : "seasons.id"}").where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit")
    .group("split_name") #.order("split_name DESC")
  end
  
  def splits_by_month(season_id)
    StatLine.joins(:game => :season).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        "AVG(points) as points, #{season_id} as season_id, COUNT(*) as game_count, to_char(games.date, 'Month') as split_name").where(player_id: self.id).where("seasons.id = #{season_id != -1 ? season_id : "seasons.id"}").where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit") 
    .group("split_name") #.sort_by { |split| DateTime.strptime(split.split_name, '%B') }
  end
  
  def splits_by_time(season_id)
    StatLine.joins(:game => :season).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        "AVG(points) as points, #{season_id} as season_id, COUNT(*) as game_count, to_char(games.date, 'FMHH:MI AM') as split_name").where(player_id: self.id).where("seasons.id = #{season_id != -1 ? season_id : "seasons.id"}").where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit")
    .group("split_name") #.sort_by { |split| DateTime.strptime(split.split_name, '%l:%M %p') }
  end
  
  def splits_by_opponent(season_id)
    StatLine.joins(:game => :season).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        "AVG(points) as points, #{season_id} as season_id, COUNT(*) as game_count, (SELECT name FROM teams WHERE id = (case when games.home_team_id = team_id then games.away_team_id else games.home_team_id end) limit 1) as split_name").where(player_id: self.id).where("seasons.id = #{season_id != -1 ? season_id : "seasons.id"}").where("dnp is null OR not dnp")
        .where("games.forfeit is null OR not games.forfeit").group("split_name") #.order("split_name")
  end
  
  def abc_plus(season = nil)
    abc_plus = self.abc_plus_scores.where(season_id: season || Season.current).first
    abc_plus.try(:score) || 0
  end
  
  def calc_stats(season)
    calc_season_stats(season)
    calc_career_stats
  end
  
  def recalc_all_stats
    self.roster_spots.map(&:season).uniq.each do |season|
      calc_season_stats(season)
    end
    calc_career_stats
  end
  
  def calc_season_stats(season)
    set_player_stats('season_average', self.season_averages(season))
    set_player_stats('season_total', self.season_totals(season))
    set_abc_plus(season)
    
    set_player_splits('splits_by_results', self.splits_by_result(season.id))
    set_player_splits('splits_by_month', self.splits_by_month(season.id))
    set_player_splits('splits_by_time', self.splits_by_time(season.id))
    set_player_splits('splits_by_opponent', self.splits_by_opponent(season.id))
  end
  
  def calc_career_stats
    set_player_totals('career_per_game_average', self.career_averages)
    set_player_totals('career_per_season_average', self.average_per_season_totals)
    
    set_player_splits('splits_by_results', self.splits_by_result(-1))
    set_player_splits('splits_by_month', self.splits_by_month(-1))
    set_player_splits('splits_by_time', self.splits_by_time(-1))
    set_player_splits('splits_by_opponent', self.splits_by_opponent(-1))
    
    set_career_high('points', :points)
    set_career_high('rebounds', :trb)
    set_career_high('assists', :ast)
    set_career_high('steals', :stl)
    set_career_high('blocks', :blk)
    set_career_high('fouls', :fl)
    set_career_high('threem', :threem)
    set_career_high('ftm', :ftm)
  end
  
  def set_player_stats(stat_type, stats)
    stats.each do |s|
      player_stat = self.player_stats.where(stat_type: stat_type).where(season_id: s.season_id).where(team_id: s.team_id).first_or_initialize
      player_stat.attributes = {game_count: s.game_count, points: s.points, season_number: s.season_number, fgm: s.fgm, fga: s.fga, fgpct: s.fgpct, twom: s.twom, twoa: s.twoa, twopct: s.twopct, threem: s.threem, threea: s.threea, threepct: s.threepct, ftm: s.ftm, fta: s.fta, ftpct: s.ftpct, orb: s.orb, drb: s.drb, trb: s.trb, ast: s.ast, stl: s.stl, blk: s.blk, fl: s.fl, to: s.to}
      player_stat.save
    end
  end
  
  def set_player_totals(stat_type, s)
    return if not s
    
    player_stat = self.player_stats.where(stat_type: stat_type).first_or_initialize
    player_stat.attributes = {game_count: s.game_count, points: s.points, fgm: s.fgm, fga: s.fga, fgpct: s.fgpct, twom: s.twom, twoa: s.twoa, twopct: s.twopct, threem: s.threem, threea: s.threea, threepct: s.threepct, ftm: s.ftm, fta: s.fta, ftpct: s.ftpct, orb: s.orb, drb: s.drb, trb: s.trb, ast: s.ast, stl: s.stl, blk: s.blk, fl: s.fl, to: s.to}
    player_stat.save
  end
  
  def set_player_splits(stat_type, stats)
    stats.each do |s|
      player_stat = self.player_stats.where(stat_type: stat_type).where(split_name: s.split_name).where(season_id: s.season_id).first_or_initialize
      player_stat.attributes = {game_count: s.game_count, points: s.points, fgm: s.fgm, fga: s.fga, fgpct: s.fgpct, twom: s.twom, twoa: s.twoa, twopct: s.twopct, threem: s.threem, threea: s.threea, threepct: s.threepct, ftm: s.ftm, fta: s.fta, ftpct: s.ftpct, orb: s.orb, drb: s.drb, trb: s.trb, ast: s.ast, stl: s.stl, blk: s.blk, fl: s.fl, to: s.to}
      player_stat.save
    end
  end
  
  def set_career_high(stat_type, stat_field)
    max_stat = self.stat_lines.order("#{stat_field} DESC").first #self.stat_lines.max_by { |stat| stat.send(stat_field) }
    unless max_stat.nil?
      career_high = self.career_highs.where(stat_type: stat_type).first_or_initialize
      if career_high.new_record? || max_stat.send(stat_field) > career_high.value
        career_high.value = max_stat.send(stat_field)
        career_high.game = career_high.value == 0 ? "N/A" : "#{max_stat.game.season.name} vs. #{max_stat.game.home_team_id == max_stat.team_id ? max_stat.game.away_team.name : max_stat.game.home_team.name}"
        career_high.game_id = max_stat.game.id if career_high.value != 0
        career_high.save
      end
    end
  end
  
  def set_abc_plus(season)
    #return 0 unless self.stat_lines.joins(:game).where("games.season_id" => season).any?
    
    totals = self.player_stats.where(stat_type: 'season_total').where(season_id: season).first
    #totals = self.season_totals(season)
    #team = self.team_by_season(season)
    
    return if not totals
    
    season_averages = self.player_stats.where(stat_type: 'season_average').where(season_id: totals.season_id).first
    
    team = Team.find(totals.team_id)
    #team_totals = team.season_totals(totals.season_id)
    team_totals = team.player_stats.where(stat_type: 'team_season_total').where(season_id: totals.season_id).first
    
    rebound_rate = team_totals.trb == 0 ? 0 : totals.trb / team_totals.trb
    effective_assists = team_totals.fgm == 0 ? 0 : totals.ast / team_totals.fgm
    ft_pct = totals.fta == 0 ? 0 : totals.ftm / totals.fta
    defensive_measure = totals.stl + totals.blk + totals.fl
    approx_value = ((totals.points + totals.trb + totals.ast + totals.stl + totals.blk - (totals.fta - totals.ftm) - (totals.fga - totals.fgm)).abs ** 0.75) / 21.0
    offensive_measure = totals.fgm + (0.5 * totals.threem) + (0.25 * totals.ftm)
    points_per_game = season_averages.points # self.season_averages(season).points
    
    score = (0.03 * team.abc_plus_win_pct(totals.season_id)) + (0.05 * rebound_rate) + (0.05 * effective_assists) + (0.07 * ft_pct) + (0.12 * defensive_measure) + (0.18 * approx_value) + (0.3 * offensive_measure) + (0.2 * points_per_game)
    
    abc_plus = self.abc_plus_scores.where(season_id: totals.season_id).first_or_initialize
    abc_plus.update_attributes(score: score.to_f)
  end
  
  #PRIVATE METHODS
  private

  def first_or_last
    if (first_name.blank? && last_name.blank?)
      errors[:base] << "Specify at least a first or last name."
    end
  end
end