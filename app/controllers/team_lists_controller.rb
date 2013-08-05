class TeamListsController < ApplicationController
  def edit
    @season = Season.find(params[:id])
    @new_team = Team.new
    @new_division = Division.new
    @all_teams = @season.teams.any? ? Team.where('id not in (?)', @season.teams.map(&:id)) : Team.all
  end

  def add
    season = Season.find(params[:id])
    team_id = params[:team_id]
    team = team_id ? Team.find(team_id) : Team.create(params[:team])
    
    season.teams << team

    redirect_to team_list_edit_season_url(season)
  end

  def remove
    season = Season.find(params[:id])
    season.teams.delete(Team.find(params[:team_id]))

    redirect_to team_list_edit_season_url(season)
  end
  
  def set_division
    params[:team_spots].each do |id, ts|
      team_spot = TeamSpot.find(id)
      team_spot.update_attributes(ts)
    end
    
    redirect_to team_list_edit_season_url(params[:id]), notice: 'Changes were saved successfully.'
  end
end