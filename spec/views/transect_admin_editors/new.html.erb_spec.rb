require 'rails_helper'

RSpec.describe "transect_admin_editors/new", type: :view do
  before(:each) do
    assign(:transect_admin_editor, TransectAdminEditor.new(
      :transect => nil,
      :admin => nil
    ))
  end

  it "renders new transect_admin_editor form" do
    render

    assert_select "form[action=?][method=?]", transect_admin_editors_path, "post" do

      assert_select "input[name=?]", "transect_admin_editor[transect_id]"

      assert_select "input[name=?]", "transect_admin_editor[admin_id]"
    end
  end
end
