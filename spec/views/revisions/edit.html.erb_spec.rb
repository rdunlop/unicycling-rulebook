require 'spec_helper'

describe "revisions/edit" do
  before(:each) do
    @revision = assign(:revision, FactoryGirl.create(:revision))
    @proposal = @revision.proposal
  end

  it "renders the edit revision form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => proposal_revisions_path(@proposal, @revision), :method => "post" do
      assert_select "textarea#revision_body", :name => "revision[body]"
      assert_select "textarea#revision_background", :name => "revision[background]"
      assert_select "textarea#revision_references", :name => "revision[references]"
      assert_select "textarea#revision_change_description", :name => "revision[change_description]"
    end
  end
end
