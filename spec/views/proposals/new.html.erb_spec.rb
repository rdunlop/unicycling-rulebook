require 'spec_helper'

describe "proposals/new" do
  before(:each) do
    @proposal = FactoryGirl.create(:proposal)
    @revision = FactoryGirl.create(:revision, :proposal => @proposal)
    @committees = [FactoryGirl.create(:committee)]
  end

  it "renders new proposal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => proposals_path, :method => "post" do
      assert_select "select#proposal_committee_id", :name => "proposal[committee_id]"
      assert_select "input#proposal_title", :name => "proposal[title]"

      assert_select "textarea#revision_body", :name => "revision[body]"
      assert_select "textarea#revision_background", :name => "revision[background]"
      assert_select "textarea#revision_references", :name => "revision[references]"
    end
  end
end
