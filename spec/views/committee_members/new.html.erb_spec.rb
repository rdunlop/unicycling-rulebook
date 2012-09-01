require 'spec_helper'

describe "committee_members/new" do
  before(:each) do
    assign(:committee_member, FactoryGirl.create(:committee_member))
  end

  it "renders new proposal form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => committee_members_path, :method => "post" do
      assert_select "select#committee_member_committee_id", :name => "committee_member[committee_id]"
      assert_select "select#committee_member_user_id", :name => "committee_member[user_id]"
      assert_select "input#committee_member_voting", :name => "committee_member[voting]"
    end
  end
end
