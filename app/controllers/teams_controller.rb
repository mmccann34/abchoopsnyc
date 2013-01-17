class TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])
    if @team.save
      redirect_to teams_path
    else
      render action: "new", flash: { error: "An error occurred while creating Team." }
    end
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      redirect_to teams_url, notice: "Team has successfully been updated."
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
  end

  def show
  end
end
