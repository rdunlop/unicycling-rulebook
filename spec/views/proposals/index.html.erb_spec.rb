require 'spec_helper'

describe "proposals/index" do
  before(:each) do
    assign(:proposals, [
      stub_model(Proposal,
        :committee_id => 1,
        :status => "Status",
        :transition_straight_to_vote => false,
        :owner_id => 2,
        :summary => "MyText",
        :title => "OtherText"
      ),
      stub_model(Proposal,
        :committee_id => 1,
        :status => "Status",
        :transition_straight_to_vote => false,
        :owner_id => 2,
        :summary => "MyText",
        :title => "OtherText"
      )
    ])
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
