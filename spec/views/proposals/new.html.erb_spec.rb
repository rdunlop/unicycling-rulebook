require 'spec_helper'

describe "proposals/new" do
  before(:each) do
    @proposal = FactoryGirl.build_stubbed(:proposal)
    @revision = FactoryGirl.build_stubbed(:revision, :proposal => @proposal)
  end

  it "renders new proposal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => proposals_path, :method => "post" do
      assert_select "input#proposal_title", :name => "proposal[title]"

      assert_select "textarea#revision_body", :name => "revision[body]"
      assert_select "textarea#revision_background", :name => "revision[background]"
      assert_select "textarea#revision_references", :name => "revision[references]"
    end
  end
end
