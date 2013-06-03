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
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      redirect_to edit_location_url(@location), notice: "Location has been updated."
    else
      render action: "edit", flash: { error: "An error occurred while updating Location." }
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
