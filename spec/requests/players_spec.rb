require 'spec_helper'

describe "Players" do
  describe "GET /players" do
    it "display some players" do
      visit players_path
      page.should have_content 'Matt McCann'
    end
  end
end
