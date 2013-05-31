class RostersController < ApplicationController
  def edit
    season_id = params[:season]
    if season_id
      @selected_season = Season.find(season_id)
    else
      @selected_season = Season.current
    end
    
    @seasons = Season.order("id DESC").all
    
    @team = Team.find(params[:id])
    @all_players = @team.roster(@selected_season.id).any? ? Player.where('id not in (?)', @team.roster(@selected_season.id).map(&:id)) : Player.all
    @new_player = Player.new
  end

  def add
    team = Team.find(params[:id])
    player_id = params[:player_id]
    season_id = params[:season_id]
    player = player_id ? Player.find(player_id) : Player.create(params[:player])
    
    team.roster_spots << RosterSpot.create(player_id: player.id, season_id: season_id)

    redirect_to roster_edit_team_url(team, season: season_id)
  end

  def remove
    team = Team.find(params[:id])
    team.roster_spots.delete(RosterSpot.find_by_player_id_and_season_id(params[:player_id], params[:season_id]))

    redirect_to roster_edit_team_url(team, season: params[:season_id])
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