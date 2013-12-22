class StatsController < ActionController::Base
  layout "stats"
  before_filter :load_sidebar

  def index
  end
  
  def info
  end
  
  def media
  end
  
  def store
  end
  
  def news
  end
  
  def get_standings
    @is_index = params[:index] == "true"
    respond_to do |format|
      format.js { render partial: "get_standings" }
    end
  end
  
  def get_players
    respond_to do |f|
      headers['Access-Control-Allow-Origin'] = '*'
      f.json { render json: Player.all.map {|p| {value: p.name, tokens: p.name.split(' '), id: p.id, pic_url: p.profile_pic_thumb_url, number: p.last_number, team: p.last_team.try(:name)}} }
    end
  end
  
  def player_search
    @results = Player.where("(display_name <> '' and display_name ILIKE :search) or ((display_name = '' or display_name is null) and (first_name ILIKE :search or last_name ILIKE :search or (trim(first_name) || ' ' || last_name) ILIKE :search))", search: "%#{params[:player]}%").order("case when display_name <> '' then display_name else last_name end").order("case when display_name <> '' then '' else first_name end").page(params[:page])
    if @results.count == 1
      redirect_to stats_player_url(@results.first)
    end
  end
  
  def show_boxscore
    @game = Game.find_by_id(params[:id])
    if !@game
      redirect_to 'http://www.abchoopsnyc.com' and return
    end
    
    @ot_one = @game.home_score_ot_one != 0 || @game.away_score_ot_one != 0
    @ot_two = @game.home_score_ot_two != 0 || @game.away_score_ot_two != 0
    @ot_three = @game.home_score_ot_three != 0 || @game.away_score_ot_three != 0
    @divisions = @game.season.divisions
    @current_season = @game.season
    @thumb_width = 149
    if @game.photo_urls && @game.photo_urls.count < 5
      case @game.photo_urls.count
      when 4
        @thumb_width = 187
      when 3
        @thumb_width = 249
      when 2
        @thumb_width = 374
      end
    end
  end
  
  def show_team
    begin
      @team = Team.find(params[:id])
    rescue
      redirect_to 'http://www.abchoopsnyc.com' and return
    end

    @seasons = @team.team_spots.joins(:season).order("seasons.number desc").map(&:season).uniq
    @current_season = params[:season] ? Season.find(params[:season]) : @seasons.first
    @team_spot = @team.team_spots.where(season_id: @current_season).first
    
    @schedule = @team.games(@current_season)
    @roster = @team.roster(@current_season)
    
    @per_game_player_stats = @team.player_stats.where(stat_type: 'season_average').where(season_id: @current_season).index_by(&:player_id) #@team.per_game_player_stats(@current_season)
    @per_game_stats = @team.player_stats.where(stat_type: 'team_per_game_average').where(season_id: @current_season).first #@team.per_game_stats(@current_season)
    @cumulative_player_stats = @team.player_stats.where(stat_type: 'season_total').where(season_id: @current_season).index_by(&:player_id) #@team.cumulative_player_stats(@current_season)
    @cumulative_team_stats = @team.player_stats.where(stat_type: 'team_season_total').where(season_id: @current_season).first
  end
  
  def show_schedules
    @show_all = true
    if params[:season] && params[:league]
      @season = Season.find_by_id(params[:season])
      @league = League.find_by_id(params[:league])
      if @season && @league
        @show_all = false
          @games = @league.games(@season).order(:date).select{|game| not game.week.nil?}.group_by { |game| game.week }
          @teams = @league.teams(@season)
      end
    end
  end
  
  def show_schedule
    @current_season = params[:season] ? Season.find(params[:season]) : Season.current
    @league = params[:league] ? League.find(params[:league]) : League.find_by_name("Sunday")  
    @games = @league.games(@current_season).order(:date).select{|game| not game.week.nil?}.group_by { |game| game.week }
    @teams = @league.teams(@current_season)
  end
  
  def show_results
    @show_all = true
    if params[:season] && params[:league]
      @season = Season.find_by_id(params[:season])
      @league = League.find_by_id(params[:league])
      if @season && @league
        @show_all = false
        @team_spots = TeamSpot.where(season_id: @season).where(league_id: @league)
        @team_stats = PlayerStat.where(stat_type: 'team_per_game_average').where(season_id: @season).where(league_id: @league)
        
        season_game_count = Season.find(@season).played_games.map(&:date).map(&:at_beginning_of_week).uniq.count
        min_games = season_game_count / 2
        
        #leaderboard
        @leaderboard = {}
        @leaderboard[:points] = get_records('points', 'season_average', season_id: @season, league_id: @league, count: 5, min_games: min_games)
        @leaderboard[:rebounds] = get_records('trb', 'season_average', season_id: @season, league_id: @league, count: 5, min_games: min_games)
        @leaderboard[:assists] = get_records('ast', 'season_average', season_id: @season, league_id: @league, count: 5, min_games: min_games)
        @leaderboard[:blocks] = get_records('blk', 'season_average', season_id: @season, league_id: @league, count: 5, min_games: min_games)
        @leaderboard[:steals] = get_records('stl', 'season_average', season_id: @season, league_id: @league, count: 5, min_games: min_games)
        @leaderboard[:fgpct] = get_records('fgpct', 'season_average', season_id: @season, league_id: @league, count: 5, min_games: min_games)
        @leaderboard[:threepct] = get_records('threepct', 'season_average', season_id: @season, league_id: @league, count: 5, min_games: min_games)
        @leaderboard[:ftpct] = get_records('ftpct', 'season_average', season_id: @season, league_id: @league, count: 5, min_games: min_games)
        @leaderboard[:ftm] = get_records('ftm', 'season_average', season_id: @season, league_id: @league, count: 5, min_games: min_games)
      end
    end
  end
  
  def show_player
    begin
      @player = Player.find(params[:id])
    rescue
      redirect_to 'http://www.abchoopsnyc.com' and return
    end
    
    player_stats = @player.player_stats.where("stat_type not like 'splits_%'")
    
    @seasons = @player.roster_spots.joins(:season).order("seasons.number desc").map(&:season).uniq
#    @season = params[:season] ? Season.find(params[:season]) : @seasons.first
    @show_stats = @seasons.any?
    
    career_season = Season.new(name: "Career")
    career_season.id = -1
    
    param_season = params[:splits] || params[:log]
    if param_season
      if param_season == "-1"
        @season = career_season
      else
        @season = Season.find(param_season)
      end
    else
      @season = @seasons.any? ? @seasons.first : career_season
    end
    
    @seasons = [career_season].concat(@seasons)
    
    @game_log = @player.game_log(@season)
    #@per_game_stats = player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.season_id == @season.id }.sort_by{|ps| ps.team_id}.first #@player.per_game_stats(@log_season)
    @season_highs = get_highs([[:points, 'Points'], [:trb, 'Rebounds'], [:ast, 'Assists'], [:stl, 'Steals'], [:blk, 'Blocks'], [:threem, '3PT Made'], [:ftm, 'FTM']], @player, @season) if @season.id != -1

    @career_season_averages = player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.team_id != -1  }.sort_by{ |ps| ps.season_number }.reverse! #@player.career_season_averages
    @career_averages = player_stats.select{ |ps| ps.stat_type == 'career_per_game_average' }.first || StatLine.new #@player.career_averages
    @career_season_totals = player_stats.select{ |ps| ps.stat_type == 'season_total' }.sort_by{ |ps| ps.season_number }.reverse! #@player.career_season_totals
    #@average_per_season_totals = player_stats.select{ |ps| ps.stat_type == 'career_per_season_average' }.first # @player.average_per_season_totals
    @current_season_averages = player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.season_id == Season.current.id }.sort_by{|ps| ps.team_id}.first || StatLine.new #@player.season_averages(Season.current)
    @career_totals = player_stats.select{ |ps| ps.stat_type == 'career_total' }.first
    
#    @career_highs = Hash[@player.career_highs.map{ |ch| [ch.stat_type, ch] }]
    @career_highs = get_highs([[:points, 'Points'], [:trb, 'Rebounds'], [:ast, 'Assists'], [:stl, 'Steals'], [:blk, 'Blocks'], [:threem, '3PT Made'], [:ftm, 'FTM']], @player)
    
    splits_stats = @player.player_stats.where("stat_type like 'splits_%'").where(season_id: @season)
    @all_splits = {}
    team_ids = @season.id == -1 ? [-1] : @player.roster_spots.where(season_id: @season).map(&:team_id).uniq
    team_ids.each do |team_id|
      @all_splits[team_id] = {}
      @all_splits[team_id]['By Result'] = splits_stats.select{ |ps| ps.stat_type == 'splits_by_results' && (team_id == -1 || ps.team_id == team_id) }.sort_by{ |ps| ps.split_name }.reverse!
      @all_splits[team_id]['By Month'] = splits_stats.select{ |ps| ps.stat_type == 'splits_by_month' && (team_id == -1 || ps.team_id == team_id) }.sort_by{ |ps| DateTime.strptime(ps.split_name, '%B') }
      @all_splits[team_id]['By Time'] = splits_stats.select{ |ps| ps.stat_type == 'splits_by_time' && (team_id == -1 || ps.team_id == team_id) }.sort_by{ |ps| DateTime.strptime(ps.split_name, '%l:%M %p') }
      @all_splits[team_id]['By Opponent'] = splits_stats.select{ |ps| ps.stat_type == 'splits_by_opponent' && (team_id == -1 || ps.team_id == team_id) }.sort_by{ |ps| ps.split_name }
      @all_splits[team_id]['By Arena'] = splits_stats.select{ |ps| ps.stat_type == 'splits_by_location' && (team_id == -1 || ps.team_id == team_id) }.sort_by{ |ps| ps.split_name }
      @all_splits[team_id]['Totals'] = @season.id == -1 ? @career_averages : player_stats.select{ |ps| ps.stat_type == 'season_average' && ps.season_id == @season.id && (team_id == -1 || ps.team_id == team_id) }.first
    end
  end
  
  def show_record_books
    @highs = {}
    @highs[:points] = get_all_time_highs('points')
    @highs[:rebounds] = get_all_time_highs('trb')
    @highs[:assists] = get_all_time_highs('ast')
    @highs[:blocks] = get_all_time_highs('blk')
    @highs[:steals] = get_all_time_highs('stl')
    @highs[:fgm] = get_all_time_highs('fgm')
    @highs[:threem] = get_all_time_highs('threem')
    @highs[:ftm] = get_all_time_highs('ftm')
    
    @career_totals = {}
    @career_totals[:points] = get_records('points', 'career_total')
    @career_totals[:rebounds] = get_records('trb', 'career_total')
    @career_totals[:assists] = get_records('ast', 'career_total')
    @career_totals[:blocks] = get_records('blk', 'career_total')
    @career_totals[:steals] = get_records('stl', 'career_total')
    @career_totals[:fgpct] = get_records('fgpct', 'career_total')
    @career_totals[:threepct] = get_records('threepct', 'career_total')
    @career_totals[:ftpct] = get_records('ftpct', 'career_total')
    @career_totals[:ftm] = get_records('ftm', 'career_total')
    @career_totals[:threem] = get_records('threem * 3', 'career_total')
    @career_totals[:doubles] = get_records('double_double', 'career_total')
    @career_totals[:games] = get_records('game_count', 'career_total')
    
    @career_averages = {}
    @career_averages[:points] = get_records('points', 'career_per_game_average')
    @career_averages[:rebounds] = get_records('trb', 'career_per_game_average')
    @career_averages[:assists] = get_records('ast', 'career_per_game_average')
    @career_averages[:blocks] = get_records('blk', 'career_per_game_average')
    @career_averages[:steals] = get_records('stl', 'career_per_game_average')
    @career_averages[:fgpct] = get_records('fgpct', 'career_per_game_average')
    @career_averages[:threepct] = get_records('threepct', 'career_per_game_average')
    @career_averages[:ftpct] = get_records('ftpct', 'career_per_game_average')
    @career_averages[:ftm] = get_records('ftm', 'career_per_game_average')
    @career_averages[:threem] = get_records('threem * 3', 'career_per_game_average')
    
    @season = params[:season] ? Season.find(params[:season]) : Season.current
    season_game_count = Season.find(@season).played_games.map(&:date).map(&:at_beginning_of_week).uniq.count
    min_games = season_game_count / 2
    @season_totals = {}
    @season_totals[:points] = get_records('points', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:rebounds] = get_records('trb', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:assists] = get_records('ast', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:blocks] = get_records('blk', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:steals] = get_records('stl', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:fgpct] = get_records('fgpct', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:threepct] = get_records('threepct', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:ftpct] = get_records('ftpct', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:ftm] = get_records('ftm', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:threem] = get_records('threem * 3', 'season_total', season_id: @season, min_games: min_games)
    @season_totals[:doubles] = get_records('double_double', 'season_total', season_id: @season, min_games: min_games)
    
    @season_averages = {}
    @season_averages[:points] = get_records('points', 'season_average', season_id: @season, min_games: min_games)
    @season_averages[:rebounds] = get_records('trb', 'season_average', season_id: @season, min_games: min_games)
    @season_averages[:assists] = get_records('ast', 'season_average', season_id: @season, min_games: min_games)
    @season_averages[:blocks] = get_records('blk', 'season_average', season_id: @season, min_games: min_games)
    @season_averages[:steals] = get_records('stl', 'season_average', season_id: @season, min_games: min_games)
    @season_averages[:fgpct] = get_records('fgpct', 'season_average', season_id: @season, min_games: min_games)
    @season_averages[:threepct] = get_records('threepct', 'season_average', season_id: @season, min_games: min_games)
    @season_averages[:ftpct] = get_records('ftpct', 'season_average', season_id: @season, min_games: min_games)
    @season_averages[:ftm] = get_records('ftm', 'season_average', season_id: @season, min_games: min_games)
    @season_averages[:threem] = get_records('threem * 3', 'season_average', season_id: @season, min_games: min_games)
  end
  
  private
  def load_sidebar
    @divisions = Season.current.divisions
    @current_season = Season.current
  end
  
  def get_highs(stat_fields, player, season = nil)
    results = {}
    player_stats = season ? player.season_stats(season) : player.stat_lines
    stat_fields.each do |stat_field|
      stat = player_stats.order("#{stat_field[0]} DESC").first
      if stat
        value = stat.send(stat_field[0])
        game = value == 0 ? "N/A" : "#{season ? stat.game.boxscore_week_name : stat.game.season.name} vs. #{stat.vs_team.name}"
        results[stat_field[1]] = CareerHigh.new(value: value, game: game, game_id: stat.game.id)
      end
    end
    results
  end

  def get_all_time_highs(stat_field)
    StatLine.joins(:player).joins(:game).joins("JOIN teams t ON vs_team_id = t.id").select("players.id as id, players.slug, players.first_name, players.last_name, 
players.display_name, players.profile_pic_thumb_url, #{stat_field} as total, stat_lines.team_id, stat_lines.game_id,
to_char(games.date, 'FMMM/FMDD/YY') || ' vs. ' || t.abbreviation as game_desc")
            .order("#{stat_field} desc").limit(10)
  end

  def get_records(stat_field, stat_type, options={})
    options = {season_id: nil, league_id: nil, count: 10, min_games: 16}.merge(options)
    minimum = "game_count >= #{options[:min_games]}"
    is_total = stat_type.end_with? 'total'
    case stat_field
    when "fgpct"
      minimum += is_total ? " and fga/game_count >= 8" : " and fga >= 8"
    when "threepct"
      minimum += is_total ? " and threea/game_count >= 3" : " and threea >= 3"
    when "ftpct"
      minimum += is_total ? " and fta/game_count >= 4" : " and fta >= 4"
    end
    
    query = PlayerStat.joins(:player).joins(:team)
                      .where(stat_type: stat_type).where(season_id: options[:season_id]).where("player_stats.team_id <> -1")
    query = query.where("#{minimum}")
    query = query.where(league_id: options[:league_id]) if options[:league_id]
    
query.select("players.id, players.slug, players.first_name, players.last_name, players.display_name, players.profile_pic_thumb_url, #{stat_field} as total, player_stats.team_id, teams.abbreviation as team_name, teams.slug as team_slug")
         .order("#{stat_field} desc").limit(options[:count])
  end
end