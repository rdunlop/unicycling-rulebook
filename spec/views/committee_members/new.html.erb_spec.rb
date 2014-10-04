require 'spec_helper'

describe "committee_members/new", :type => :view do
  before(:each) do
    @cm = assign(:committee_member, FactoryGirl.create(:committee_member))
    @committee = @cm.committee
    @users = [FactoryGirl.create(:user)]
  end

  it "renders new committee Member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => committee_committee_members_path(@committee), :method => "post" do
      assert_select "select#committee_member_user_id", :name => "committee_member[user_id]"
      assert_select "input#committee_member_voting", :name => "committee_member[voting]"
      assert_select "input#committee_member_admin", :name => "committee_member[admin]"
      assert_select "input#committee_member_editor", :name => "committee_member[editor]"
    end
  end
end
