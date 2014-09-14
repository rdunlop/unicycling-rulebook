require 'spec_helper'

describe "committees/show" do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end


  it "renders a link to create a new proposal when none exist" do
    @committee = FactoryGirl.create(:committee)
    @proposals = []
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/No proposals exist yet/)
  end

  describe "when a proposal exists" do
    before(:each) do
      @committee = FactoryGirl.create(:committee)
      @proposal = FactoryGirl.create(:proposal)
      @proposals = [@proposal]
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
