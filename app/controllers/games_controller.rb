class GamesController < ApplicationController
  def index
    season_id = params[:season]
    if season_id
      @selected_season = Season.find(season_id)
    else
      @selected_season = Season.current
    end

    @games = Game.order("date DESC").where(season_id: @selected_season.id) if @selected_season
    @seasons = Season.order("id DESC").all
  end

  def new
    season_id = params[:season]
    if season_id
      @selected_season = Season.find(season_id)
    else
      @selected_season = Season.current
    end
    
    @teams = @selected_season.teams.order(:name)
    @seasons = Season.order("id DESC").all
    
    @games = []
    11.times { @games.append(Game.new) }
    @times = get_times("AM")
    @times.concat get_times("PM")


  end

  def create
    season_id = params[:season_id]
    date = DateTime.strptime(params[:date], '%m/%d/%Y')
    league_id = params[:league_id]
    location_id = params[:location_id]
    params[:games].values.each do |game|
      game[:season_id] = season_id
      time = Time.parse(game[:time]) rescue nil
      if time
        game[:date] = date.change(hour: time.hour, min: time.min)
      else
        game[:date] = date
      end
      game[:league_id] = league_id
      game[:location_id] = location_id
      Game.create(game)
    end

    redirect_to games_url
  end

  def edit
    @game = Game.find(params[:id])
    @times = get_times("AM")
    @times.concat get_times("PM")
  end

  def update
    @game = Game.find(params[:id])
    game_update = params[:game]
    date = DateTime.strptime(game_update[:date], '%m/%d/%Y')
    time = Time.parse(game_update[:time]) rescue nil
    if time
      game_update[:date] = date.change(hour: time.hour, min: time.min)
    else
      game_update[:date] = date
    end
    set_photo_urls
    if @game.update_attributes(game_update)
      redirect_to edit_game_url(@game), notice: "Game has successfully been updated."
    else
      render action: "edit", flash: { error: "An error occurred while updating Game." }
    end
  end
  
  def set_photo_urls
    if not @game.photo_urls
      @game.photo_urls = []
    else
      @game.photo_urls.clear
    end
    
    params[:photo_urls].each do |index, value|
      if not value.blank?
        @game.photo_urls << value
      end
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

  def resave
    Game.all.each do |g|
      g.save
    end

    redirect_to games_url
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