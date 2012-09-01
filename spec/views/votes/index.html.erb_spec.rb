require 'spec_helper'

describe "votes/index" do
  before(:each) do
    @proposal = FactoryGirl.create(:proposal)
    assign(:votes, [
        FactoryGirl.create(:vote, :proposal => @proposal),
        FactoryGirl.create(:vote, :proposal => @proposal)])
  end

  it "renders a list of votes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @proposal.title.to_s, :count => 2
    assert_select "tr>td", :text => "agree".to_s, :count => 2
  end
end
