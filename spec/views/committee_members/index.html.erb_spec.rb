require 'spec_helper'

describe "committee_members/index", type: :view do
  before(:each) do
    @committee = FactoryGirl.create(:committee)
    @cm = assign(:committee_members, [
            FactoryGirl.create(:committee_member, committee: @committee, admin: true, voting: false),
            FactoryGirl.create(:committee_member, committee: @committee, voting: false)])
  end

  it "renders a list of committee_members" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: @cm.first.user.to_s, count: 1
    assert_select "tr>td", text: @cm.last.user.to_s, count: 1
    assert_select "tr>td", text: @cm.first.admin.to_s, count: 1
  end
end
