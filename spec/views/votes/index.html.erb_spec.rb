require 'spec_helper'

describe "votes/index", type: :view do
  before(:each) do
    @proposal = FactoryGirl.create(:proposal)
    @user = FactoryGirl.create(:user)
    assign(:votes, [
        FactoryGirl.create(:vote, proposal: @proposal, user: @user),
        FactoryGirl.create(:vote, proposal: @proposal)
])
  end

  it "renders a list of votes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: @user.to_s, count: 1
    assert_select "tr>td", text: "agree".to_s, count: 2
  end
end
