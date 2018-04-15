require 'rails_helper'

RSpec.describe "transects/new", type: :view do
  before(:each) do
    assign(:transect, Transect.new(
      :transect_name => "MyString",
      :transect_code => "MyString",
      :target_slope => 1,
      :target_aspect => 1
    ))
  end

  it "renders new transect form" do
    render

    assert_select "form[action=?][method=?]", transects_path, "post" do

      assert_select "input[name=?]", "transect[transect_name]"

      assert_select "input[name=?]", "transect[transect_code]"

      assert_select "input[name=?]", "transect[target_slope]"

      assert_select "input[name=?]", "transect[target_aspect]"
    end
  end
end
