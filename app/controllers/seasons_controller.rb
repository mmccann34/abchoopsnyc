class SeasonsController < ApplicationController
  def index
    @seasons = Season.order("id DESC").all
    @new_season = Season.new
    @current_season = Season.current
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
    @new_team = Team.new
    @all_teams = @season.teams.any? ? Team.where('id not in (?)', @season.teams.map(&:id)) : Team.all
  end

  def update
    @season = Season.find(params[:id])
    if @season.update_attributes(params[:season])
      redirect_to edit_season_url(@season), notice: "Season has been updated."
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

  def set_current
    current_season = Season.current
    current_season.update_attribute(:current, false) if current_season

    new_id = params[:current_season]
    if not new_id.empty?
      season = Season.find(new_id)
      season.update_attribute(:current,  true)
    end

    redirect_to seasons_url, notice: "Current Season has been set."
  end
end