require 'spec_helper'

describe "committees/show", type: :view do
  describe "when a proposal exists" do
    before(:each) do
      @committee = FactoryBot.create(:committee)
      @proposal = FactoryBot.create(:proposal)
      @proposals = [@proposal]
      assign(:votes, [
          FactoryBot.create(:vote, proposal: @proposal),
          FactoryBot.create(:vote, proposal: @proposal)
])
      render
    end
    it "should find the proposal title" do
      expect(rendered).to match(@proposal.title)
    end
  end
end
