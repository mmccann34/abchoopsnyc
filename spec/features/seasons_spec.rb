# require 'spec_helper'

# describe "Seasons" do
#   before do
#     @season = seasons(:w12)
#   end

#   describe "GET /seasons" do
#     it "display some seasons" do
#       visit seasons_path
#       page.should have_content 'Winter 2012'
#     end

#     it "creates a new season" do
#       visit new_season_path
#       fill_in 'Name', with: 'New Season'
#       fill_in 'Key', with: 'newseason'
#       click_button 'Create Season'

#       current_path.should == seasons_path
#       page.should have_content 'New Season'
#     end
#   end

#   describe "PUT /seasons" do
#     it "edits a season" do
#       visit seasons_path
#       find("#season_#{@season.id}").click_link 'Edit'

#       current_path.should == edit_season_path(@season)

#       find_field('Name').value.should == @season.name
#       find_field('Key').value.should == @season.key

#       fill_in 'Name', with: 'Winter 2013'
#       fill_in 'Key', with: 'winter2013'
#       click_button 'Update Season'

#       current_path.should == seasons_path

#       page.should have_content 'Winter 2013 (winter2013)'
#     end

#     it "should not update a season without a name" do
#       visit seasons_path
#       find("#season_#{@season.id}").click_link 'Edit'

#       fill_in 'Name', with: ''
#       click_button 'Update Season'

#       current_path.should == season_path(@season)
#       page.should have_content "can't be blank"
#     end
#   end

#   describe "DELETE /seasons" do
#     it "should delete a season" do
#       visit seasons_path
#       find("#season_#{@season.id}").click_link 'Delete'
#       page.should have_content 'Season has been deleted.'
#       page.should have_no_content 'Game, Blouses'
#     end
#   end
# end