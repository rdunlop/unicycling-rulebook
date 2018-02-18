require 'spec_helper'

describe "proposals/new", type: :view do
  let(:committee) { FactoryBot.create(:committee) }
  before(:each) do
    @proposal = Proposal.new
    @revision = FactoryBot.build_stubbed(:revision, proposal: @proposal)
    @committee = committee
    @available_discussions = []
  end

  it "renders new proposal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: committee_proposals_path(committee), method: "post" do
      assert_select "input#proposal_title", name: "proposal[title]"

      assert_select "textarea#revision_body", name: "revision[body]"
      assert_select "textarea#revision_background", name: "revision[background]"
      assert_select "textarea#revision_references", name: "revision[references]"
    end
  end
end
