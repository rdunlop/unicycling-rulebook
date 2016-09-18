require 'spec_helper'

describe "proposals/show", type: :view do
  before(:each) do
    @proposal = FactoryGirl.create(:proposal, title: "thetitle")
    @revision = FactoryGirl.create(:revision, proposal: @proposal, background: "thebackground")
    @proposal.reload
    @discussion = FactoryGirl.create(:discussion, proposal: @proposal)
    @comment = @discussion.comments.new
    @vote = @proposal.votes.new
    allow(view).to receive(:policy).and_return double(create?: false, read_usernames?: false, set_review?: false, revise?: false, vote?: false)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/thetitle/)
    expect(rendered).to match(/thebackground/)
  end
  describe "with a voting-state proposal" do
    before(:each) do
      @proposal = FactoryGirl.create(:proposal, title: "thetitle", status: "Voting")
      @revision = FactoryGirl.create(:revision, proposal: @proposal, background: "thebackground")
      @proposal.reload
      @discussion = FactoryGirl.create(:discussion, proposal: @proposal)

      @comment = @proposal.comments.new
      @vote = @proposal.votes.new
    end
    it "renders vote when in correct state" do
      render

      expect(rendered).to match(/thetitle/)
    end
  end
end
