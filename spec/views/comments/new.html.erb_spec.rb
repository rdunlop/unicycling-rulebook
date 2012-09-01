require 'spec_helper'

describe "comments/new" do
  before(:each) do
    @proposal = FactoryGirl.create(:proposal)
    assign(:comment, FactoryGirl.create(:comment, :proposal => @proposal))
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => proposal_comments_path(@proposal), :method => "post" do
      assert_select "textarea#comment_comment", :name => "comment[comment]"
    end
  end
end
