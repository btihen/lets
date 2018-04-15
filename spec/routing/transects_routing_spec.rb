require "rails_helper"

RSpec.describe TransectsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/transects").to route_to("transects#index")
    end

    it "routes to #new" do
      expect(:get => "/transects/new").to route_to("transects#new")
    end

    it "routes to #show" do
      expect(:get => "/transects/1").to route_to("transects#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/transects/1/edit").to route_to("transects#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/transects").to route_to("transects#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/transects/1").to route_to("transects#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/transects/1").to route_to("transects#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/transects/1").to route_to("transects#destroy", :id => "1")
    end

  end
end
