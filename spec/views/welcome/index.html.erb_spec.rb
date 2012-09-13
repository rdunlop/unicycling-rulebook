require 'spec_helper'

describe "welcome/index" do
  before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
  end


  it "renders a link to create a new proposal when none exist" do
    @committees = []
    @proposals = []
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/No proposals exist yet/)
  end

  describe "when a proposal exists" do
    before(:each) do
        @proposal = FactoryGirl.create(:proposal)
        @proposals = [@proposal]
        @committees = [@proposals.first.committee]
        assign(:votes, [
            FactoryGirl.create(:vote, :proposal => @proposal),
            FactoryGirl.create(:vote, :proposal => @proposal)])
        render
    end
    it "should find the proposal title" do
        rendered.should match(@proposal.title)
    end
  end
end
