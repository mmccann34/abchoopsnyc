class StatsController < ApplicationController
  layout "stats"
  before_filter :load_sidebar

  def recalc_stats
    if params[:player_id]
      player = Player.find_by_id(params[:player_id])
      player.calc_stats if player
    else
      Player.all.each do |player|
        player.calc_stats
      end
    end
    
    redirect_to :root
  end
  
  def show_boxscore
    @game = Game.find_by_id(params[:id])
    @ot_one = @game.home_score_ot_one != 0 || @game.away_score_ot_one != 0
    @ot_two = @game.home_score_ot_two != 0 || @game.away_score_ot_two != 0
    @ot_three = @game.home_score_ot_three != 0 || @game.away_score_ot_three != 0
    if !@game
      redirect_to games_url, flash: { error: "Game does not exist." }
    end
    @divisions = @game.season.divisions
    @current_season = @game.season
  end
  
  def show_team
    @team = Team.find_by_id(params[:id])

    @seasons = @team.team_spots.joins(:season).order("seasons.number desc").map(&:season)
    @current_season = params[:season] ? Season.find(params[:season]) : @seasons.first
    @team_spot = @team.team_spots.where(season_id: @current_season).first
    
    @schedule = @team.games(@current_season)
    @roster = @team.roster(@current_season)
    
    @per_game_player_stats = @team.player_stats.where(stat_type: 'season_average').where(season_id: @current_season).index_by(&:player_id) #@team.per_game_player_stats(@current_season)
    @per_game_stats = @team.player_stats.where(stat_type: 'team_per_game_average').where(season_id: @current_season).first #@team.per_game_stats(@current_season)
    @cumulative_player_stats = @team.player_stats.where(stat_type: 'season_total').where(season_id: @current_season).index_by(&:player_id) #@team.cumulative_player_stats(@current_season)
    @cumulative_team_stats = @team.player_stats.where(stat_type: 'team_season_total').where(season_id: @current_season).first
  end
  
  def show_schedules
    @seasons = Season.order("number DESC")
    @leagues = League.all
  end
  
  def show_schedule
    @current_season = params[:season] ? Season.find(params[:season]) : Season.current
    @league = params[:league] ? League.find(params[:league]) : League.find_by_name("Sunday")  
    @games = @league.games(@current_season).order(:date).select{|game| not game.week.nil?}.group_by { |game| game.week }
    @teams = @league.teams(@current_season)
  end
  
  def show_player 
    @player = Player.find_by_id(params[:id])
    player_stats = @player.player_stats
    
    @seasons = @player.roster_spots.joins(:season).order("seasons.number desc").map(&:season).uniq
    @show_stats = @seasons.any?
    
    @log_season = params[:log] ? Season.find(params[:log]) : @seasons.first
    @game_log = @player.game_log(@log_season)
    @per_game_stats = player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.season_id == @log_season.id }.sort_by{|ps| ps.team_id}.first #@player.per_game_stats(@log_season)

    @career_season_averages = player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.team_id != -1  }.sort_by{ |ps| ps.season_number }.reverse! #@player.career_season_averages
    @career_averages = player_stats.select{ |ps| ps.stat_type == 'career_per_game_average' }.first || StatLine.new #@player.career_averages
    @career_season_totals = player_stats.select{ |ps| ps.stat_type == 'season_total' }.sort_by{ |ps| ps.season_number }.reverse! #@player.career_season_totals
    @average_per_season_totals = player_stats.select{ |ps| ps.stat_type == 'career_per_season_average' }.first # @player.average_per_season_totals
    @current_season_averages = player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.season_id == Season.current.id }.sort_by{|ps| ps.team_id}.first || StatLine.new #@player.season_averages(Season.current)
    @career_totals = player_stats.select{ |ps| ps.stat_type == 'career_total' }.first
    
    @career_highs = Hash[@player.career_highs.map{ |ch| [ch.stat_type, ch] }]

    career_splits = Season.new(name: "Career")
    career_splits.id = -1
    @seasons_splits = [career_splits].concat(@seasons)
    
    if params[:splits]
      if params[:splits] == "-1"
        @splits_season = career_splits
      else
        @splits_season = Season.find(params[:splits])
      end
    else
      @splits_season = @seasons.any? ? @seasons.first : career_splits
    end
    
    @splits = Hash.new
    @splits['By Result'] = player_stats.select{ |ps| ps.stat_type == 'splits_by_results' && ps.season_id == @splits_season.id }.sort_by{ |ps| ps.split_name }.reverse! #@player.splits_by_result(@splits_season)
    @splits['By Month'] = player_stats.select{ |ps| ps.stat_type == 'splits_by_month' && ps.season_id == @splits_season.id }.sort_by{ |ps| DateTime.strptime(ps.split_name, '%B') } #@player.splits_by_month(@splits_season)
    @splits['By Time'] = player_stats.select{ |ps| ps.stat_type == 'splits_by_time' && ps.season_id == @splits_season.id }.sort_by{ |ps| DateTime.strptime(ps.split_name, '%l:%M %p') } # @player.splits_by_time(@splits_season)
    @splits['By Opponent'] = player_stats.select{ |ps| ps.stat_type == 'splits_by_opponent' && ps.season_id == @splits_season.id }.sort_by{ |ps| ps.split_name } # @player.splits_by_opponent(@splits_season)
    @splits_totals = @splits_season.id == -1 ? @career_averages : player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.season_id == @splits_season.id }.first #@player.season_averages(@splits_season) 
  end
  
  def show_record_books
    @career_totals = {}
    @career_totals[:points] = get_career_records('points', 'career_total')
    @career_totals[:rebounds] = get_career_records('trb', 'career_total')
    @career_totals[:assists] = get_career_records('ast', 'career_total')
    @career_totals[:blocks] = get_career_records('blk', 'career_total')
    @career_totals[:steals] = get_career_records('stl', 'career_total')
    @career_totals[:fgpct] = get_career_records('fgpct', 'career_total')
    @career_totals[:threepct] = get_career_records('threepct', 'career_total')
    @career_totals[:ftpct] = get_career_records('ftpct', 'career_total')
    @career_totals[:ftm] = get_career_records('ftm', 'career_total')
    @career_totals[:threem] = get_career_records('threem * 3', 'career_total')
    
    @career_averages = {}
    @career_averages[:points] = get_career_records('points', 'career_per_game_average')
    @career_averages[:rebounds] = get_career_records('trb', 'career_per_game_average')
    @career_averages[:assists] = get_career_records('ast', 'career_per_game_average')
    @career_averages[:blocks] = get_career_records('blk', 'career_per_game_average')
    @career_averages[:steals] = get_career_records('stl', 'career_per_game_average')
    @career_averages[:fgpct] = get_career_records('fgpct', 'career_per_game_average')
    @career_averages[:threepct] = get_career_records('threepct', 'career_per_game_average')
    @career_averages[:ftpct] = get_career_records('ftpct', 'career_per_game_average')
    @career_averages[:ftm] = get_career_records('ftm', 'career_per_game_average')
    @career_averages[:threem] = get_career_records('threem * 3', 'career_per_game_average')
    
    @season_totals_season = params[:stotals] ? Season.find(params[:stotals]) : Season.current
    @season_totals = {}
    @season_totals[:points] = get_career_records('points', 'season_total', @season_totals_season)
    @season_totals[:rebounds] = get_career_records('trb', 'season_total', @season_totals_season)
    @season_totals[:assists] = get_career_records('ast', 'season_total', @season_totals_season)
    @season_totals[:blocks] = get_career_records('blk', 'season_total', @season_totals_season)
    @season_totals[:steals] = get_career_records('stl', 'season_total', @season_totals_season)
    @season_totals[:fgpct] = get_career_records('fgpct', 'season_total', @season_totals_season)
    @season_totals[:threepct] = get_career_records('threepct', 'season_total', @season_totals_season)
    @season_totals[:ftpct] = get_career_records('ftpct', 'season_total', @season_totals_season)
    @season_totals[:ftm] = get_career_records('ftm', 'season_total', @season_totals_season)
    @season_totals[:threem] = get_career_records('threem * 3', 'season_total', @season_totals_season)
    
    @season_averages_season = params[:spergame] ? Season.find(params[:spergame]) : Season.current
    @season_averages = {}
    @season_averages[:points] = get_career_records('points', 'season_average', @season_averages_season)
    @season_averages[:rebounds] = get_career_records('trb', 'season_average', @season_averages_season)
    @season_averages[:assists] = get_career_records('ast', 'season_average', @season_averages_season)
    @season_averages[:blocks] = get_career_records('blk', 'season_average', @season_averages_season)
    @season_averages[:steals] = get_career_records('stl', 'season_average', @season_averages_season)
    @season_averages[:fgpct] = get_career_records('fgpct', 'season_average', @season_averages_season)
    @season_averages[:threepct] = get_career_records('threepct', 'season_average', @season_averages_season)
    @season_averages[:ftpct] = get_career_records('ftpct', 'season_average', @season_averages_season)
    @season_averages[:ftm] = get_career_records('ftm', 'season_average', @season_averages_season)
    @season_averages[:threem] = get_career_records('threem * 3', 'season_average', @season_averages_season)
  end
  
  private
  def load_sidebar
    @divisions = Season.current.divisions
    @current_season = Season.current
  end

  def get_career_records(stat_field, stat_type, season_id = nil)
    PlayerStat.joins(:player).joins(:team).where(stat_type: stat_type).where("player_stats.team_id <> -1").where(season_id: season_id)  #.where("#{stat_field} <> 0")
              .select("player_id, players.first_name, players.last_name, players.profile_pic_thumb_url, #{stat_field} as total, player_stats.team_id, teams.abbreviation as team_name")
              .order("#{stat_field} desc").limit(10)
  end
end