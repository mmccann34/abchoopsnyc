require 'spec_helper'

describe Game do
  before do
    @home_team = teams(:gb)
    @away_team = teams(:teamx)
    @season = seasons(:w12)
    @game = Game.create(season_id: @season.id, home_team_id: @home_team.id, away_team_id: @away_team.id)
  end

  it "should have a home team and an away team" do
    @game.home_team.name.should == @home_team.name
    @game.away_team.name.should == @away_team.name
  end

  it "should return stats by team" do
    player = Player.create(first_name: "Matt", last_name: "McCann", key: "MattMcCann")
    stat_line = StatLine.create(game_id: @game.id, team_id: @home_team.id, player_id: player.id)
    player_two = Player.create(first_name: "Lewis", last_name: "Tse", key: "LewisTse")
    stat_line_two = StatLine.create(game_id: @game.id, team_id: @away_team.id, player_id: player_two.id)

    @game.team_stats(@home_team.id).count.should == 1
    @game.team_stats(@away_team.id).count.should == 1
  end

  it "should create stat lines after creation" do
    player = Player.create(first_name: "Matt", last_name: "McCann", key: "MattMcCann", team_id: @home_team.id)
    player_two = Player.create(first_name: "Lewis", last_name: "Tse", key: "LewisTse", team_id: @home_team.id)
    new_game = Game.create(season_id: 1, home_team_id: @home_team.id, away_team_id: @away_team.id)

    new_game.stat_lines.count.should == 2
  end

  it "should create stat lines if they are missing" do
    @game.home_team.players << Player.create(first_name: "Matt", last_name: "McCann", key: "MattMcCann")
    @game.home_team.players << Player.create(first_name: "Lewis", last_name: "Tse", key: "LewisTse")

    @game.create_stat_lines
    @game.stat_lines.count.should == 2
  end
end