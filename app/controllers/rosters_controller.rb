class RostersController < ApplicationController
  def edit
    season_id = params[:season]
    if season_id
      @selected_season = Season.find(season_id)
    else
      @selected_season = Season.current
    end
    
    @seasons = Season.order("id DESC").all
    
    gon.team_id = params[:id]
    gon.season_id = @selected_season.id
    
    @team = Team.find(params[:id])
    #@all_players = @team.roster(@selected_season.id).any? ? Player.where('id not in (?)', @team.roster(@selected_season.id).map(&:player)) : Player.all
    @new_player = Player.new
  end

  def add
    team = Team.find(params[:id])
    player_id = params[:player_id]
    season_id = params[:season_id]
    player = player_id ? Player.find(player_id) : Player.create(params[:player])

    if player.id
      team.roster_spots << RosterSpot.create(player_id: player.id, season_id: season_id)
      if URI(request.referer).path.end_with?("boxscore/edit")
        redirect_to :back
      else
        redirect_to roster_edit_team_url(team, season: season_id)
      end
    else
      error = player.errors[:base].any? ? player.errors[:base][0] : "An error occurred while adding Player."
      redirect_to roster_edit_team_url(team, season: season_id), flash: { error: error }
    end
  end
  
  def edit_number
    #render text: params
    params[:roster_spots].each do |id, rs|
      roster_spot = RosterSpot.find(id)
      roster_spot.update_attributes(rs)
    end
    
    redirect_to roster_edit_team_url(params[:id], season: params[:season_id]), notice: "Jersey #s have been updated."
  end

  def remove
    RosterSpot.delete(params[:roster_spot_id])
    team = Team.find(params[:id])

    redirect_to roster_edit_team_url(params[:id], season: params[:season_id])
  end
end