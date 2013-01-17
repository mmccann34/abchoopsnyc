class SeasonsController < ApplicationController
  def index
    @seasons = Season.all
  end

  def new
    @season = Season.new
  end

  def create
    @season = Season.new(params[:season])
    if @season.save
      redirect_to seasons_url
    else
      render action: "new",  flash: { error: "An error occurred while creating Season." }
    end
  end

  def edit
    @season = Season.find(params[:id])
  end

  def update
    @season = Season.find(params[:id])
    if @season.update_attributes(params[:season])
      redirect_to seasons_url, notice: "Season has successfully been updated."
    else
      render action: "edit", flash: { error: "An error occurred while updating Season." }
    end
  end

  def destroy
    @season = Season.find(params[:id])
    if @season.destroy
      redirect_to seasons_url, notice: "Season has been deleted."
    else
      redirect_to seasons_url, flash: { error: "An error occurred while deleting Season."}
    end
  end
end
