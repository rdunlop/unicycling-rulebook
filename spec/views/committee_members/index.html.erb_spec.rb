require 'spec_helper'

describe "committee_members/index" do
  before(:each) do
    @committee = FactoryGirl.create(:committee)
    assign(:committee_members, [
            FactoryGirl.create(:committee_member, :committee => @committee),
            FactoryGirl.create(:committee_member, :committee => @committee)])
  end

  it "renders a list of proposals" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "OtherText".to_s, :count => 2
  end
end
