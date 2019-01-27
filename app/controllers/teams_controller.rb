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

  def refresh_google_calendar
    # Initialize the Google API
    client = Google::Apis::CalendarV3::CalendarService.new
    client.authorization = Google::Auth.get_application_default(Google::Apis::CalendarV3::AUTH_CALENDAR) 

    team = Team.find(params[:id])
    if team.google_calendar_id
      team.games().each do |game|
        event = create_google_calendar_event(team, game)
        if game.google_calendar_id
          client.update_event(team.google_calendar_id, game.google_calendar_id, event)
        else
          result = client.insert_event(team.google_calendar_id, event)
          game.update_attributes(google_calendar_id: result.id)
        end
      end
    end

    redirect_to teams_url, notice: "Calendar refreshed"
  end
  
  def save_changes
    params[:teams].each do |id, t|
      team = Team.find(id)
      if team.name != params[:teams][id][:name]
        team.slug = nil
      end
      team.update_attributes(t)
    end
    
    redirect_to teams_url, notice: 'Changes were saved successfully.'
  end

  private
  def create_google_calendar_event(team, game)
    opponent = game.home_team_id == team.id ? game.away_team.name : game.home_team.name
    game_time = game.date.to_time()
    # case game.location_id
    # when 7
    #   location = '273 Bowery, New York, NY 10002'
    # when 2
    #   location = '411 Pearl St, New York, NY 10038'
    # else
    #   location = ''
    # end
    event = Google::Apis::CalendarV3::Event.new({
      summary: "Game vs. #{opponent}",
      description: "http://stats.abchoopsnyc.com/games/#{game.id}/boxscore"
      start: {
        date_time: game.date.strftime('%FT%T'),
        time_zone: 'America/New_York',
      },
      end: {
        date_time: game.date.change(hour: game_time.hour + 1, min: game_time.min).strftime('%FT%T'),
        time_zone: 'America/New_York',
      },
      location: "#{game.location}, New York, NY",
    })
    return event
  end
end