class RostersController < ApplicationController
  def edit
    @team = Team.find(params[:id])
    @all_players = @team.players.any? ? Player.where('id not in (?)', @team.players.map(&:id)) : Player.all
    @new_player = Player.new
  end

  def add
    @team = Team.find(params[:id])
    player_id = params[:player_id]
    if player_id
      @team.players << Player.find(player_id)
    else
      @team.players << Player.create(params[:player])
    end

    redirect_to roster_edit_team_url(@team)
  end

  def remove
    @team = Team.find(params[:id])
    @team.players.delete(Player.find(params[:player_id]))

    redirect_to roster_edit_team_url(@team)
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

    redirect_to roster_game_url(game), notice: 'Box Score successfully updated.'
  end
end