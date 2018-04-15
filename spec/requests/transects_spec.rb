require 'rails_helper'

RSpec.describe "Transects", type: :request do
  describe "GET /transects" do
    it "works! (now write some real specs)" do
      get transects_path
      expect(response).to have_http_status(200)
    end
  end
end
