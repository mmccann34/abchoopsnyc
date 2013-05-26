class GamesController < ApplicationController
  def index
    season_id = params[:season]
    if season_id
      @selected_season = Season.find(season_id)
    else
      @selected_season = Season.current
    end

    @games = Game.order("date DESC").find_all_by_season_id(@selected_season ? @selected_season.id : 0)
    @seasons = Season.order("id DESC").all
  end

  def new
    @games = []
    10.times { @games.append(Game.new) }
    @seasons = Season.order("id DESC").all
    @current_season = Season.current
    @times = get_times("AM")
    @times.concat get_times("PM")
  end

  def create
    season_id = params[:season_id]
    date = DateTime.strptime(params[:date], '%m/%d/%Y')
    location_id = params[:location_id]
    params[:games].values.each do |game|
      game[:season_id] = season_id
      time = Time.parse(game[:time]) rescue nil
      if time
        game[:date] = date.change(hour: time.hour, min: time.min)
      else
        game[:date] = date
      end
      game[:location_id] = location_id
      Game.create(game)
    end

    redirect_to games_url
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      redirect_to games_url, notice: "Game has successfully been updated."
    else
      render action: "edit", flash: { error: "An error occurred while updating Game." }
    end
  end

  def destroy
    @game = Game.find(params[:id])
    if @game.destroy
      redirect_to games_url, notice: "Game has been deleted."
    else
      redirect_to games_url, flash: { error: "An error occurred while deleting Game."}
    end
  end


  private
  def get_times(am_pm)
    times = []
    hours = ["12"]
    1.upto(11) {|h| hours.append(h.to_s)}
    minutes = ["00", "15", "30", "45"]
    hours.each do |hour|
      minutes.each do |minute|
        times << "#{hour}:#{minute} #{am_pm}"
      end
    end
    return times
  end
end