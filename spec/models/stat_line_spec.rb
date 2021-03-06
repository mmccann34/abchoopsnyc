require 'spec_helper'

describe StatLine do
  it "should be associated with a game" do
    game = Game.create(home_team_id: teams(:gb).id, away_team_id: teams(:teamx).id, season_id: seasons(:w12).id)
    stat_line = StatLine.new
    stat_line.game = game
    stat_line.game.home_team.name.should == teams(:gb).name
  end

  it "should be associated with a team" do
    stat_line = StatLine.new
    stat_line.team = teams(:gb)
    stat_line.team.name.should == teams(:gb).name
  end

  it "should calculate field goal percentage on create" do
    stat_line = StatLine.create(game_id: 1, team_id: 1, player_id: 1, fgm: 9, fga: 11)
    stat_line.fgpct.should == 9.0/11
  end

  it "should calculate field goal percentage on update" do
    stat_line = StatLine.create(game_id: 1, team_id: 1, player_id: 1, fgm: 9, fga: 11)
    stat_line.fgpct.should == 9.0/11

    stat_line.fgm = 10
    stat_line.fga = 12
    stat_line.save
    stat_line.fgpct.should == 10.0/12
  end
end