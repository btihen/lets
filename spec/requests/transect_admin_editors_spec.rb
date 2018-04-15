require 'rails_helper'

RSpec.describe "TransectAdminEditors", type: :request do
  describe "GET /transect_admin_editors" do
    it "works! (now write some real specs)" do
      get transect_admin_editors_path
      expect(response).to have_http_status(200)
    end
  end
end
