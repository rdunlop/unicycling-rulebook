require 'spec_helper'

describe "votes/new" do
  before(:each) do
    vote = assign(:vote, FactoryGirl.create(:vote))
    @proposal = vote.proposal
  end

  it "renders new vote form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => proposal_votes_path(@proposal), :method => "post" do
      assert_select "select#vote_vote", :name => "vote[vote]"
    end
  end
end
