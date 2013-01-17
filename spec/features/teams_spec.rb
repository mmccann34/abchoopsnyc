# require 'spec_helper'

# describe "Teams" do
#   before do
#     @team = teams(:gb)
#   end

#   describe "GET /teams" do
#     it "display some teams" do
#       visit teams_path
#       page.should have_content 'Game, Blouses'
#     end

#     it "creates a new team" do
#       visit new_team_path
#       fill_in 'Name', with: 'New Team'
#       click_button 'Create Team'

#       current_path.should == teams_path
#       page.should have_content 'New Team'
#     end
#   end

#   describe "PUT /teams" do
#     it "edits a team" do
#       visit teams_path
#       find("#team_#{@team.id}").click_link 'Edit'

#       current_path.should == edit_team_path(@team)

#       find_field('Name').value.should == 'Game, Blouses'

#       fill_in 'Name', with: 'Computer Blue'
#       click_button 'Update Team'

#       current_path.should == teams_path

#       page.should have_content 'Computer Blue'
#     end

#     it "should not update a team without a name" do
#       visit teams_path
#       find("#team_#{@team.id}").click_link 'Edit'

#       fill_in 'Name', with: ''
#       click_button 'Update Team'

#       current_path.should == team_path(@team)
#       page.should have_content "can't be blank"
#     end
#   end

#   describe "DELETE /teams" do
#     it "should delete a team" do
#       visit teams_path
#       find("#team_#{@team.id}").click_link 'Delete'
#       page.should have_content 'Team has been deleted.'
#       page.should have_no_content 'Game, Blouses'
#     end
#   end
# end