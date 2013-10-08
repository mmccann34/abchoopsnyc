class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :key, :height, :weight, :age, :profile_pic, :team_id, :number, :height_feet, :height_inches, :school, :position, :hometown, :day_job, :about
  validate :first_or_last

  has_attached_file :profile_pic, styles: { medium: "300x300#", profile: "200X200#", thumb: "100x100#" }

  has_many :stat_lines, dependent: :destroy
  has_many :roster_spots, dependent: :destroy
  has_many :teams, through: :roster_spots

  before_validation do
    self.key = key.strip if key
  end

  def name
    "#{first_name} #{last_name}"
  end

  def height
    "#{height_feet}-#{height_inches}"
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
  
  def per_game_stats(season)
    StatLine.find_by_sql('SELECT AVG(fgm) as fgm, AVG(fga) as fga, AVG(coalesce(fgm/nullif(fga, 0), 0)) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(coalesce(twom/nullif(twoa, 0), 0)) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(coalesce(threem/nullif(threea, 0), 0)) as threepct,' \
                        'AVG(ftm) as ftm, AVG(fta) as fta, AVG(coalesce(ftm/nullif(fta, 0), 0)) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
                        'AVG(points) as points FROM stat_lines sl INNER JOIN games g ON sl.game_id = g.id ' \
                        "WHERE (g.forfeit is null or not g.forfeit) AND (sl.dnp is null OR not sl.dnp) AND player_id = #{self.id} AND g.season_id = #{season.id}").first
  end
  
  def career_season_averages
    StatLine.joins(:game => :season).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                            'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
                                            'AVG(points) as points, seasons.number as season_number, team_id').where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").group("team_id").group("seasons.number").order("seasons.number DESC")
  end
  
  def career_averages
    StatLine.joins(:game).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
                                 'AVG(points) as points').where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").first
  end
  
  def career_season_totals
    StatLine.joins(:game => :season).select('SUM(fgm) as fgm, SUM(fga) as fga, SUM(twom) as twom, SUM(twoa) as twoa, SUM(threem) as threem, SUM(threea) as threea,' \
                    'SUM(ftm) as ftm, SUM(fta) as fta, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
                    'SUM(points) as points, seasons.number as season_number, team_id').where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").group("team_id").group("seasons.number").order("seasons.number DESC")
  end
  
  def average_per_season_totals
    StatLine.find_by_sql('SELECT AVG(fgm) as fgm, AVG(fga) as fga, AVG(coalesce(fgm/nullif(fga, 0), 0)) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(coalesce(twom/nullif(twoa, 0), 0)) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(coalesce(threem/nullif(threea, 0), 0)) as threepct,' \
                        'AVG(ftm) as ftm, AVG(fta) as fta, AVG(coalesce(ftm/nullif(fta, 0), 0)) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
                        'AVG(points) as points FROM (SELECT SUM(fgm) as fgm, SUM(fga) as fga, SUM(twom) as twom, SUM(twoa) as twoa, SUM(threem) as threem, SUM(threea) as threea,' \
                        'SUM(ftm) as ftm, SUM(fta) as fta, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
                        "SUM(points) as points FROM stat_lines sl INNER JOIN games g ON sl.game_id = g.id " \
                        "WHERE (g.forfeit is null or not g.forfeit) AND (sl.dnp is null OR not sl.dnp) AND player_id = #{self.id} GROUP BY g.season_id) sums").first
  end
  
  def season_averages(season)
    StatLine.joins(:game).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        'AVG(points) as points').where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season).first
  end
  
  def season_totals(season)
    StatLine.joins(:game).select('SUM(fgm) as fgm, SUM(fga) as fga, SUM(twom) as twom, SUM(twoa) as twoa, SUM(threem) as threem, SUM(threea) as threea,' \
                    'SUM(ftm) as ftm, SUM(fta) as fta, SUM(orb) as orb, SUM(drb) as drb, SUM(trb) as trb, SUM(ast) as ast, SUM(stl) as stl, SUM(blk) as blk, SUM(fl) as fl, SUM("to") as to,' \
                    'SUM(points) as points').where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season).first
  end
  
  def splits_by_result(season)
    StatLine.joins(:game).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        "AVG(points) as points, case when games.winner = team_id then 'In wins' else 'In losses' end as split_name ").where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season).group("split_name")
  end
  
  def splits_by_month(season)
    StatLine.joins(:game).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        "AVG(points) as points, to_char(games.date, 'Month') as split_name").where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season).group("split_name")
  end
  
  def splits_by_time(season)
    StatLine.joins(:game).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        "AVG(points) as points, to_char(games.date, 'FMHH:MI AM') as split_name").where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season).group("split_name")
  end
  
  def splits_by_opponent(season)
    StatLine.joins(:game).select('AVG(fgm) as fgm, AVG(fga) as fga, AVG(fgpct) as fgpct, AVG(twom) as twom, AVG(twoa) as twoa, AVG(twopct) as twopct, AVG(threem) as threem, AVG(threea) as threea, AVG(threepct) as threepct,' \
                                 'AVG(ftm) as ftm, AVG(fta) as fta, AVG(ftpct) as ftpct, AVG(orb) as orb, AVG(drb) as drb, AVG(trb) as trb, AVG(ast) as ast, AVG(stl) as stl, AVG(blk) as blk, AVG(fl) as fl, AVG("to") as to,' \
        "AVG(points) as points, case when games.home_team_id = team_id then games.away_team_id else games.home_team_id end as split_name").where(player_id: self.id).where("dnp is null OR not dnp").where("games.forfeit is null OR not games.forfeit").where("games.season_id" => season).group("split_name").each do |split|
          split.split_name = 'vs. ' + Team.find(split.split_name).try(:name)
        end
  end
  
  def abc_plus(season)
    totals = self.season_totals(season)
    team = self.team_by_season(season)
    team_totals = team.season_totals(season)
    
    rebound_rate = team_totals.trb == 0 ? 0 : totals.trb / team_totals.trb
    effective_assists = team_totals.fgm == 0 ? 0 : totals.ast / team_totals.fgm
    ft_pct = totals.fta == 0 ? 0 : totals.ftm / totals.fta
    defensive_measure = totals.stl + totals.blk + totals.fl
    approx_value = ((totals.points + totals.trb + totals.ast + totals.stl + totals.blk - (totals.fta - totals.ftm) - (totals.fga - totals.fgm)) ** 0.75) / 21.0
    offensive_measure = totals.fgm + (0.5 * totals.threem) + (0.25 * totals.ftm)
    points_per_game = self.season_averages(season).points
    
    #results = Hash.new
    #results["pyth expe"] = 0.03 * team.abc_plus_win_pct(season)
    #results["reb rate"] = 0.05 * rebound_rate
    #results["effect assist"] = 0.05 * effective_assists
    #results["ft%"] = 0.07 * ft_pct
    #results["def measure"] = 0.12 * defensive_measure
    #results["approx value"] = 0.18 * approx_value
    #results["off measure"] = 0.3 * offensive_measure
    #results["ppg"] = 0.2 * points_per_game
    #results["total"] = (0.03 * team.abc_plus_win_pct(season)) + (0.05 * rebound_rate) + (0.05 * effective_assists) + (0.07 * ft_pct) + (0.12 * defensive_measure) + (0.18 * approx_value) + (0.3 * offensive_measure) + (0.2 * points_per_game)
    #results
    
    (0.03 * team.abc_plus_win_pct(season)) + (0.05 * rebound_rate) + (0.05 * effective_assists) + (0.07 * ft_pct) + (0.12 * defensive_measure) + (0.18 * approx_value) + (0.3 * offensive_measure) + (0.2 * points_per_game)
  end
  
  #PRIVATE METHODS
  private

  def first_or_last
    if (first_name.blank? && last_name.blank?)
      errors[:base] << "Specify at least a first or last name."
    end
  end
end