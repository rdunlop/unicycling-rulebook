require 'spec_helper'

describe "votes/show" do
  before(:each) do
    @vote = assign(:vote, FactoryGirl.create(:vote))
    @proposal = @vote.proposal
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # XXX rendered.should match(/@proposal/)
    rendered.should match(/agree/)
  end
end
