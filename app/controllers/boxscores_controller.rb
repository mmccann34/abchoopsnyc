class BoxscoresController < ApplicationController
  def show
    @game = Game.find_by_id(params[:id])
    @ot_one = @game.home_score_ot_one != 0 || @game.away_score_ot_one != 0
    @ot_two = @game.home_score_ot_two != 0 || @game.away_score_ot_two != 0
    @ot_three = @game.home_score_ot_three != 0 || @game.away_score_ot_three != 0
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
      
      if params[:game][:forfeit] != "1"
        params[:stat_lines].each do |stat_line_id, stat_line_params|
          if !stat_line_id.starts_with?'sub'
            stat = StatLine.find_by_id(stat_line_id)
          else
            team_id = stat_line_id.split('_')[1]
            stat = StatLine.create(team_id: team_id, player_id: -1)
            game.stat_lines << stat
          end
          stat.update_attributes(stat_line_params)
        end
        
        ###Calculate Stats###
        game.home_team.calc_stats(game.season)
        game.home_team.roster(game.season).each do |rs|
          rs.player.calc_stats(game.season)
        end
        
        game.away_team.calc_stats(game.season)
        game.away_team.roster(game.season).each do |rs|
          rs.player.calc_stats(game.season)
        end        
      end
    end

    redirect_to boxscore_edit_game_url(game), notice: 'Box Score successfully updated.'
  end
end