require 'spec_helper'

describe "revisions/index" do
  before(:each) do
    @revs = assign(:revisions, [
        FactoryGirl.create(:revision),
        FactoryGirl.create(:revision)])
    @proposal = @revs.first.proposal
  end

  it "renders a list of revisions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @revs.first.proposal.to_s, :count => 1
    assert_select "tr>td", :text => @revs.last.proposal.to_s, :count => 1
    assert_select "tr>td", :text => @revs.first.body.to_s, :count => 2
  end
end
