require 'spec_helper'

describe TeamsController, :type => :controller do

  context "when logged out" do
    describe "GET 'index'" do
      it "redirects to sign in" do
        get 'index'
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "when logged in" do
    describe "GET 'index'" do
      it "displays list of players" do
        login_admin
        get 'index'
        expect(response).to be_success
      end
    end
  end
end