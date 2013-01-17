# require 'spec_helper'

# describe "Games" do
#   before do
#     @home_team = teams(:gb)
#     @away_team = teams(:teamx)
#     @season = seasons(:w12)
#     @game = Game.create(season_id: @season.id, home_team_id: @home_team.id, away_team_id: @away_team.id)
#   end

#   describe "GET /games" do
#     it "display some games" do
#       visit games_path
#       page.should have_content 'Team X @ Game, Blouses'
#     end

#     it "creates a new game" do
#       visit new_game_path
#       select @season.name, from: 'Season'
#       select @away_team.name, from: 'Home team'
#       select @home_team.name, from: 'Away team'
#       click_button 'Create Game'

#       current_path.should == games_path
#       page.should have_content 'Game, Blouses @ Team X'
#     end
#   end

#   describe "PUT /games" do
#     it "edits a game" do
#       visit games_path
#       click_link 'Edit'

#       current_path.should == edit_game_path(@game)

#       new_team = teams(:cb)
#       find_field('Home team').value.should == @home_team.id.to_s

#       select new_team.name, from: 'Home team'
#       click_button 'Update Game'

#       current_path.should == games_path

#       page.should have_content 'Team X @ Computer Blue'
#     end
#   end

#   describe "DELETE /games" do
#     it "should delete a game" do
#       visit games_path
#       find("#game_#{@game.id}").click_link 'Delete'
#       page.should have_content 'Game has been deleted.'
#       page.should have_no_content 'Team X @ Game, Blouses'
#     end
#   end
# end