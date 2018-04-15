require 'rails_helper'

RSpec.describe "transects/show", type: :view do
  before(:each) do
    @transect = assign(:transect, Transect.create!(
      :transect_name => "Transect Name",
      :transect_code => "Transect Code",
      :target_slope => 2,
      :target_aspect => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Transect Name/)
    expect(rendered).to match(/Transect Code/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
