require 'rails_helper'

RSpec.describe "transect_admin_editors/index", type: :view do
  before(:each) do
    assign(:transect_admin_editors, [
      TransectAdminEditor.create!(
        :transect => nil,
        :admin => nil
      ),
      TransectAdminEditor.create!(
        :transect => nil,
        :admin => nil
      )
    ])
  end

  it "renders a list of transect_admin_editors" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
