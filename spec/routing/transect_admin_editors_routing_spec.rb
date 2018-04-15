require "rails_helper"

RSpec.describe TransectAdminEditorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/transect_admin_editors").to route_to("transect_admin_editors#index")
    end

    it "routes to #new" do
      expect(:get => "/transect_admin_editors/new").to route_to("transect_admin_editors#new")
    end

    it "routes to #show" do
      expect(:get => "/transect_admin_editors/1").to route_to("transect_admin_editors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/transect_admin_editors/1/edit").to route_to("transect_admin_editors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/transect_admin_editors").to route_to("transect_admin_editors#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/transect_admin_editors/1").to route_to("transect_admin_editors#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/transect_admin_editors/1").to route_to("transect_admin_editors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/transect_admin_editors/1").to route_to("transect_admin_editors#destroy", :id => "1")
    end

  end
end
