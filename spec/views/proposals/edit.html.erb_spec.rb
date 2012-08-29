require 'spec_helper'

describe "proposals/edit" do
  before(:each) do
    @proposal = assign(:proposal, stub_model(Proposal,
      :committee_id => 1,
      :status => "MyString",
      :transition_straight_to_vote => false,
      :owner_id => 1,
      :summary => "MyText",
      :title => "MyText"
    ))
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
