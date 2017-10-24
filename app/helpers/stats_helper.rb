module StatsHelper
  def last_five(game_team)
    last_five = @all_games.where("home_team_id = ? OR away_team_id = ?", game_team.id, game_team.id).where("winner IS NOT NULL").order('date ASC' ).last(5)
  end
end