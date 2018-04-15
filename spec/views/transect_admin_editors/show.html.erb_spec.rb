require 'rails_helper'

RSpec.describe "transect_admin_editors/show", type: :view do
  before(:each) do
    @transect_admin_editor = assign(:transect_admin_editor, TransectAdminEditor.create!(
      :transect => nil,
      :admin => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
