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
  end
  
  private
  
  def load_sidebar
    @divisions = Season.current.divisions
  end
end