class TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])
    if @team.save
      redirect_to teams_url, notice: "Team has successfully been created."
    else
      redirect_to teams_url, flash: { error: "An error occurred while creating Team." }
    end
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      params[:players].each do |player_id, player_params|
        if player_params[:id] != ""
          player = Player.find(player_params[:id])
          player.update_attributes(player_params)
        elsif player_params[:first_name] != ""
          @team.players << Player.create(player_params)
        end
      end
      redirect_to edit_team_url(@team), notice: "Team has successfully been updated."
    else
      render action: "edit", flash: { error: "An error occurred while updating Team." }
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def destroy
    @team = Team.find(params[:id])
    if @team.destroy
      redirect_to teams_url, notice: "Team has been deleted."
    else
      redirect_to teams_url, flash: { error: "An error occurred while deleting Team." }
    end
  end

  def index
    @teams = Team.all
    @new_team = Team.new
  end

  def show
    @team = Team.find(params[:id])
    if !@team
      redirect_to teams_url, flash: { error: "Team does not exist." }
    end
  end
  
  def save_changes
    params[:teams].each do |id, t|
      team = Team.find(id)
      team.update_attributes(t)
    end
    
    redirect_to teams_url, notice: 'Changes were saved successfully.'
  end
end