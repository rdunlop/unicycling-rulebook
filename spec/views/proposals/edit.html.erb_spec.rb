require 'spec_helper'

describe "proposals/edit" do
  before(:each) do
    @proposal = FactoryGirl.create(:proposal)
    @revision = FactoryGirl.create(:revision, :proposal => @proposal)
  end

  it "renders the edit proposal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => proposals_path(@proposal), :method => "post" do
      assert_select "select#proposal_committee_id", :name => "proposal[committee_id]"
      assert_select "textarea#proposal_summary", :name => "proposal[summary]"
      assert_select "input#proposal_title", :name => "proposal[title]"
    end
  end
end
