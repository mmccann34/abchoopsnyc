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
    @new_player = Player.new
  end

  def update
    game = Game.find_by_id(params[:id])
    if !game
      redirect_to games_url, flash: { error: "Game does not exist." }
    else
      game.update_attributes(params[:game])
      
      if params[:game][:forfeit] != "1"
        stats_players = []
        params[:stat_lines].each do |stat_line_id, stat_line_params|
          if !stat_line_id.starts_with?'sub'
            stat = StatLine.find_by_id(stat_line_id)
            player_stats = [stat_line_params[:twom],stat_line_params[:twoa],stat_line_params[:threem],stat_line_params[:threea],stat_line_params[:ftm],stat_line_params[:fta],stat_line_params[:orb],stat_line_params[:drb],stat_line_params[:ast],stat_line_params[:stl],stat_line_params[:blk],stat_line_params[:fl]]
            if stat.player_id != -1 && (player_stats.uniq != ["0"])
              stats_players << stat.player
            end
          else
            team_id = stat_line_id.split('_')[1]
            stat = StatLine.create(team_id: team_id, player_id: -1)
            game.stat_lines << stat
          end
          stat.update_attributes(stat_line_params)
        end

        ###Calculate Stats###        
        game.home_team.calc_stats(game.season)        
        game.away_team.calc_stats(game.season)

        ## calc stats for all non-dnp and non-sub lines
        stats_players.each do |player|
          player.calc_stats(game.season)
        end

        game.save_top_performers
      else
        game.home_team.update_record(game.season)
        game.away_team.update_record(game.season)
      end
    end

    redirect_to boxscore_edit_game_url(game), notice: 'Box Score successfully updated.'
  end
end