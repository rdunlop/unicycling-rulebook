require 'spec_helper'

describe "revisions/edit" do
  before(:each) do
    @revision = assign(:revision, FactoryGirl.create(:revision))
  end

  it "renders the edit revision form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => revisions_path(@revision), :method => "post" do
      assert_select "input#revision_proposal_id", :name => "revision[proposal_id]"
      assert_select "textarea#revision_body", :name => "revision[body]"
      assert_select "textarea#revision_background", :name => "revision[background]"
      assert_select "textarea#revision_references", :name => "revision[references]"
      assert_select "textarea#revision_change_description", :name => "revision[change_description]"
      assert_select "input#revision_user_id", :name => "revision[user_id]"
    end
  end
end
