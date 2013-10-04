class StatsController < ApplicationController
  layout "stats"
  before_filter :load_sidebar
  
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
    if params[:season]
      @current_season = Season.find(params[:season])
    else
      @current_season = Season.current
    end
    
    @team = Team.find_by_id(params[:id])
    @schedule = @team.games(@current_season)
    @roster = @team.roster(@current_season)
    @per_game_player_stats = @team.per_game_player_stats(@current_season)
    @per_game_stats = @team.per_game_stats(@current_season)
    @cumulative_player_stats = @team.cumulative_player_stats(@current_season)
  end
  
  def show_player
    if params[:season]
      @current_season = Season.find(params[:season])
    else
      @current_season = Season.current
    end
    
    @player = Player.find_by_id(params[:id])
    @game_log = @player.game_log(@current_season)
    @per_game_stats = @player.per_game_stats(@current_season)
    @career_season_averages = @player.career_season_averages
    @career_averages = @player.career_averages
    @career_season_totals = @player.career_season_totals
    @average_per_season_totals = @player.average_per_season_totals
    @current_season_averages = @player.current_season_averages
    
    @splits = Hash.new
    @splits['By Result'] = @player.splits_by_result
    @splits['By Month'] = @player.splits_by_month
    @splits['By Time'] = @player.splits_by_time
    @splits['By Opponent'] = @player.splits_by_opponent
  end
  
  private
  def load_sidebar
    @divisions = Season.current.divisions
    @current_season = Season.current
  end
end