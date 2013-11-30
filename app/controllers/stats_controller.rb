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
    @games = @league.games(@current_season).order(:date).group_by { |game| game.week }
    @teams = @league.teams(@current_season)
  end
  
  def show_player 
    @player = Player.find_by_id(params[:id])
    player_stats = @player.player_stats
    
    @seasons = @player.roster_spots.joins(:season).order("seasons.number desc").map(&:season)
    
    @log_season = params[:log] ? Season.find(params[:log]) : @seasons.first
    @game_log = @player.game_log(@log_season)
    @per_game_stats = player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.season_id == @log_season.id }.first #@player.per_game_stats(@log_season)

    @career_season_averages = player_stats.select{ |ps| ps.stat_type == 'season_average' }.sort_by{ |ps| ps.season_number }.reverse! #@player.career_season_averages
    @career_averages = player_stats.select{ |ps| ps.stat_type == 'career_per_game_average' }.first #@player.career_averages
    @career_season_totals = player_stats.select{ |ps| ps.stat_type == 'season_total' }.sort_by{ |ps| ps.season_number }.reverse! #@player.career_season_totals
    @average_per_season_totals = player_stats.select{ |ps| ps.stat_type == 'career_per_season_average' }.first # @player.average_per_season_totals
    @current_season_averages = player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.season_id == Season.current.id }.first #@player.season_averages(Season.current)
    
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
      @splits_season = @seasons.first
    end
    
    @splits = Hash.new
    @splits['By Result'] = player_stats.select{ |ps| ps.stat_type == 'splits_by_results' && ps.season_id == @splits_season.id }.sort_by{ |ps| ps.split_name }.reverse! #@player.splits_by_result(@splits_season)
    @splits['By Month'] = player_stats.select{ |ps| ps.stat_type == 'splits_by_month' && ps.season_id == @splits_season.id }.sort_by{ |ps| DateTime.strptime(ps.split_name, '%B') } #@player.splits_by_month(@splits_season)
    @splits['By Time'] = player_stats.select{ |ps| ps.stat_type == 'splits_by_time' && ps.season_id == @splits_season.id }.sort_by{ |ps| DateTime.strptime(ps.split_name, '%l:%M %p') } # @player.splits_by_time(@splits_season)
    @splits['By Opponent'] = player_stats.select{ |ps| ps.stat_type == 'splits_by_opponent' && ps.season_id == @splits_season.id }.sort_by{ |ps| ps.split_name } # @player.splits_by_opponent(@splits_season)
    @splits_totals = @splits_season.id == -1 ? @career_averages : player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.season_id == @splits_season.id }.first #@player.season_averages(@splits_season)
  end
  
  private
  def load_sidebar
    @divisions = Season.current.divisions
    @current_season = Season.current
  end
end