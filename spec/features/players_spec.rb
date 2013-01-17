# require 'spec_helper'

# describe "Players" do
#   before do
#     @player = Player.create(first_name: "Matt", last_name: "McCann", key: "MattMcCann")
#   end

#   describe "GET /players" do
#     it "display some players" do
#       visit players_path
#       page.should have_content 'Matt McCann'
#     end

#     it "creates a new player" do
#       visit new_player_path
#       fill_in 'First name', with: 'Karl'
#       fill_in 'Last name', with: 'Laufenberg'
#       fill_in 'Key', with: 'KarlLaufenberg'
#       click_button 'Create Player'

#       current_path.should == players_path
#       page.should have_content 'Karl Laufenberg'
#     end

#     it "should not create a player with an existing key" do
#       visit new_player_path
#       fill_in 'First name', with: 'Matt'
#       fill_in 'Last name', with: 'McCann'
#       fill_in 'Key', with: 'MattMcCann'
#       click_button 'Create Player'

#       page.should have_content "has already been taken"
#     end
#   end

#   describe "PUT /players" do
#     it "edits a player" do
#       visit players_path
#       click_link 'Edit'

#       current_path.should == edit_player_path(@player)

#       find_field('First name').value.should == 'Matt'
#       find_field('Last name').value.should == 'McCann'

#       fill_in 'First name', with: 'Lewis'
#       fill_in 'Last name', with: 'Tse'
#       click_button 'Update Player'

#       current_path.should == player_path(@player)

#       page.should have_content 'Lewis Tse'
#     end

#     it "should not update a player without first and last name" do
#       visit players_path
#       click_link 'Edit'

#       fill_in 'First name', with: ''
#       click_button 'Update Player'

#       current_path.should == player_path(@player)
#       page.should have_content "can't be blank"
#     end
#   end

#   describe "DELETE /players" do
#     it "should delete a player" do
#       visit players_path
#       find("#player_#{@player.id}").click_link 'Delete'
#       page.should have_content 'Player has been deleted.'
#       page.should have_no_content 'Matt McCann'
#     end
#   end
# end
