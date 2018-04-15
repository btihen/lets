require 'rails_helper'

RSpec.describe "transects/index", type: :view do
  before(:each) do
    assign(:transects, [
      Transect.create!(
        :transect_name => "Transect Name",
        :transect_code => "Transect Code",
        :target_slope => 2,
        :target_aspect => 3
      ),
      Transect.create!(
        :transect_name => "Transect Name",
        :transect_code => "Transect Code",
        :target_slope => 2,
        :target_aspect => 3
      )
    ])
  end

  it "renders a list of transects" do
    render
    assert_select "tr>td", :text => "Transect Name".to_s, :count => 2
    assert_select "tr>td", :text => "Transect Code".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
