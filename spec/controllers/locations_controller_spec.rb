require 'spec_helper'
describe LocationsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Location. As you add validations to Location, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {  } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LocationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before(:each) do
    login_admin
  end

  describe "GET index" do
    it "assigns all locations as @locations" do
      location = Location.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:locations)).to eq([location])
    end
  end

  describe "GET show" do
    it "assigns the requested location as @location" do
      location = Location.create! valid_attributes
      get :edit, {:id => location.to_param}, valid_session
      expect(assigns(:location)).to eq(location)
    end
  end

  describe "GET new" do
    it "assigns a new location as @location" do
      get :new, {}, valid_session
      expect(assigns(:location)).to be_a_new(Location)
    end
  end

  describe "GET edit" do
    it "assigns the requested location as @location" do
      location = Location.create! valid_attributes
      get :edit, {:id => location.to_param}, valid_session
      expect(assigns(:location)).to eq(location)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Location" do
        expect {
          post :create, {:location => valid_attributes}, valid_session
        }.to change(Location, :count).by(1)
      end

      it "assigns a newly created location as @location" do
        post :create, {:location => valid_attributes}, valid_session
        expect(assigns(:location)).to be_a(Location)
        expect(assigns(:location)).to be_persisted
      end

      it "redirects to locations" do
        post :create, {:location => valid_attributes}, valid_session
        expect(response).to redirect_to(locations_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved location as @location" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Location).to receive(:save).and_return(false)
        post :create, {:location => {  }}, valid_session
        expect(assigns(:location)).to be_a_new(Location)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Location).to receive(:save).and_return(false)
        post :create, {:location => {  }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested location" do
        location = Location.create! valid_attributes
        # Assuming there are no other locations in the database, this
        # specifies that the Location created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Location).to receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => location.to_param, :location => { "these" => "params" }}, valid_session
      end

      it "assigns the requested location as @location" do
        location = Location.create! valid_attributes
        put :update, {:id => location.to_param, :location => valid_attributes}, valid_session
        expect(assigns(:location)).to eq(location)
      end

      it "redirects to the location" do
        location = Location.create! valid_attributes
        put :update, {:id => location.to_param, :location => valid_attributes}, valid_session
        expect(response).to redirect_to(locations_url)
      end
    end

    describe "with invalid params" do
      it "assigns the location as @location" do
        location = Location.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Location).to receive(:save).and_return(false)
        put :update, {:id => location.to_param, :location => {  }}, valid_session
        expect(assigns(:location)).to eq(location)
      end

      it "re-renders the 'edit' template" do
        location = Location.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Location).to receive(:save).and_return(false)
        put :update, {:id => location.to_param, :location => {  }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested location" do
      location = Location.create! valid_attributes
      expect {
        delete :destroy, {:id => location.to_param}, valid_session
      }.to change(Location, :count).by(-1)
    end

    it "redirects to the locations list" do
      location = Location.create! valid_attributes
      delete :destroy, {:id => location.to_param}, valid_session
      expect(response).to redirect_to(locations_url)
    end
  end

end
