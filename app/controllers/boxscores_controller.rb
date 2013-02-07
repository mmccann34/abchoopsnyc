class BoxscoresController < ApplicationController
  def show
    @game = Game.find_by_id(params[:id])
    if !@game
      redirect_to games_url, flash: { error: "Game does not exist." }
    end
  end

  def edit
    @game = Game.find_by_id(params[:id])
    if !@game
      redirect_to games_url, flash: { error: "Game does not exist." }
    else
      @game.create_stat_lines
    end
  end

  def update
    game = Game.find_by_id(params[:id])
    if !game
      redirect_to games_url, flash: { error: "Game does not exist." }
    else
      game.update_attributes(params[:game])

      params[:stat_lines].each do |stat_line_id, stat_line_params|
        stat = StatLine.find_by_id(stat_line_id)
        stat.update_attributes(stat_line_params)
      end
    end

    redirect_to boxscore_game_url(game), notice: 'Box Score successfully updated.'
  end
end