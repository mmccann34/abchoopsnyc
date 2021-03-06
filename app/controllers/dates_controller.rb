class DatesController < ApplicationController
  def index
    @selected_season = params[:season] ? Season.find(params[:season]) : Season.current
    @selected_league = params[:league] ? League.find(params[:league]) : League.find_by_name("Sunday")
    
    @date_ranges = DateRange.order(:start_date).where(season_id: @selected_season).where(league_id: @selected_league)
    @new_date_range = DateRange.new
    @seasons = Season.order("id DESC").all
    @leagues = League.order(:id).all
  end

  def create
    season_id = params[:season_id]
    date_range = DateRange.new(params[:date_range])
    date_range.start_date = DateTime.strptime(params[:date_range][:start_date], '%m/%d/%Y')
    date_range.end_date = DateTime.strptime(params[:date_range][:end_date], '%m/%d/%Y')
    date_range.season_id = season_id
    date_range.league_id = params[:league_id]
    if date_range.save
      redirect_to dates_url(season: season_id, league: params[:league_id])
    else
      redirect_to dates_url(season: season_id, league: params[:league_id]), flash: { error: "An error occurred while creating Date Range." }
    end
  end
  
  def edit
    @seasons = Season.order("id DESC").all
    @leagues = League.order(:id).all
    
    @selected_season = params[:season] ? Season.find(params[:season]) : Season.current
    @selected_league = params[:league] ? League.find(params[:league]) : League.find_by_name("Sunday")
    
    @date_ranges = DateRange.order(:start_date).where(season_id: @selected_season).where(league_id: @selected_league)
  end

  def update
    params[:date_ranges].each do |id, values|
      date_range = DateRange.find(id)
      values[:start_date] = DateTime.strptime(values[:start_date], '%m/%d/%Y')
      values[:end_date] = DateTime.strptime(values[:end_date], '%m/%d/%Y')
      date_range.update_attributes(values)
    end
    
    redirect_to dates_url(season: params[:season_id], league: params[:league_id]), notice: "Date Ranges have been updated."
  end

  def destroy
    date_range = DateRange.find(params[:id])
    season_id = date_range.season_id
    league_id = date_range.league_id
    if date_range.destroy
      redirect_to dates_url(season: season_id, league: league_id), notice: "Date Range has been deleted."
    else
      redirect_to dates_url(season: season_id, league: league_id), flash: { error: "An error occurred while deleting Date Range."}
    end
  end
end
