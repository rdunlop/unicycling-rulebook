require 'spec_helper'

describe "proposals/edit", type: :view do
  let(:committee) { FactoryGirl.create(:committee) }
  before(:each) do
    @proposal = FactoryGirl.create(:proposal, committee: committee)
    @revision = FactoryGirl.create(:revision, proposal: @proposal)
    @committees = [committee]
  end

  it "renders the edit proposal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: edit_proposal_path(committee, @proposal), method: "post" do
      assert_select "input#proposal_title", name: "proposal[title]"
      assert_select "select#proposal_committee_id", name: "proposal[committee_id]"
      assert_select "select#proposal_status", name: "proposal[status]"
    end
  end
end
