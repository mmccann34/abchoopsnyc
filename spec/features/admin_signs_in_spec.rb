require 'spec_helper'

feature 'Admin signs in' do
  given!(:admin) { FactoryGirl.create(:admin) }

  scenario 'with valid credentials' do
    visit new_user_session_path
    fill_in "user_email", :with => admin.email
    fill_in "user_password", :with => admin.password
    click_button "Log in"
    visit players_path
    expect(page).to have_content "#{admin.email}"
  end
end