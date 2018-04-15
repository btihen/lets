require 'rails_helper'

RSpec.describe "transect_admin_editors/edit", type: :view do
  before(:each) do
    @transect_admin_editor = assign(:transect_admin_editor, TransectAdminEditor.create!(
      :transect => nil,
      :admin => nil
    ))
  end

  it "renders the edit transect_admin_editor form" do
    render

    assert_select "form[action=?][method=?]", transect_admin_editor_path(@transect_admin_editor), "post" do

      assert_select "input[name=?]", "transect_admin_editor[transect_id]"

      assert_select "input[name=?]", "transect_admin_editor[admin_id]"
    end
  end
end
