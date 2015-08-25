require 'spec_helper'

describe "revisions/new", type: :view do
  before(:each) do
    @rev = assign(:revision, FactoryGirl.create(:revision))
    @proposal = @rev.proposal
  end

  it "renders new revision form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: proposal_revisions_path(@proposal), method: "post" do
      assert_select "textarea#revision_body", name: "revision[body]"
      assert_select "textarea#revision_rule_text", name: "revision[rule_text]"
      assert_select "textarea#revision_background", name: "revision[background]"
      assert_select "textarea#revision_references", name: "revision[references]"
      assert_select "textarea#revision_change_description", name: "revision[change_description]"
    end
  end
end
