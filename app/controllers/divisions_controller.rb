class DivisionsController < ApplicationController
  def create
    @division = Division.new(params[:division])
    @division.season_id = params[:season_id]
    if @division.save
      redirect_to team_list_edit_season_url(params[:season_id]), notice: "Division has been created."
    else
      redirect_to team_list_edit_season_url(params[:season_id]),  flash: { error: "An error occurred while creating Division." }
    end
  end

  def edit
    @season = Season.find(params[:season_id])
    @division = Division.find(params[:id])
  end

  def update 
    @division = Division.find(params[:id]) 
    if
      @division.update_attributes(params[:division]) 
      redirect_to team_list_edit_season_url(params[:season_id]), notice: "Division has been updated." 
    else
      render action: "edit", flash: { error: "An error occurred while updating Division." } 
    end 
  end

  def destroy
    @division = Division.find(params[:id])
    if @division.destroy
      redirect_to team_list_edit_season_url(params[:season_id]), notice: "Division has been deleted."
    else
      redirect_to team_list_edit_season_url(params[:season_id]), flash: { error: "An error occurred while deleting Division."}
    end
  end
end
