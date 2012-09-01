require 'spec_helper'

describe "comments/index" do
  before(:each) do
    @proposal = FactoryGirl.create(:proposal)
    assign(:comments, [
        FactoryGirl.create(:comment, :comment => "comment 1", :proposal => @proposal),
        FactoryGirl.create(:comment, :comment => "comment 2", :proposal => @proposal)])
  end

  it "renders a list of comments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "comment 1", :count => 1
    assert_select "tr>td", :text => "comment 2", :count => 1
  end
end
