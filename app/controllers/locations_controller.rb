class LocationsController < ApplicationController
def index
    @locations = Location.order(:name)
    @new_location = Location.new
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      redirect_to locations_url
    else
      render action: "new",  flash: { error: "An error occurred while creating Location." }
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
    @location = Location.find(params[:id])
    if @location.destroy
      redirect_to locations_url, notice: "Location has been deleted."
    else
      redirect_to locations_url, flash: { error: "An error occurred while deleting Location."}
    end
  end
end
