module StatsHelper
  def last_five(game_team)
    last_five = @all_games.where("home_team_id = ? OR away_team_id = ?", game_team.id, game_team.id).where("winner IS NOT NULL").order('date ASC' ).last(5)
  end

  def week_schedule_link(game)
    weeks = DateRange.where(league_id: game.league_id, season_id: game.season_id)
    game_week = weeks.where("start_date <= ? AND end_date >= ?", game.date, game.date)
    week_integer = weeks.map(&:id).index(game_week.first.id)
    require 'pry'; binding.pry 
    return (week_integer +65).chr   
  end
end