require 'spec_helper'

describe "comments/edit" do
  before(:each) do
    @comment = assign(:comment, FactoryGirl.create(:comment))
    @proposal = @comment.proposal
  end

  it "renders the edit comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => proposal_comments_path(@proposal, @comment), :method => "post" do
      assert_select "textarea#comment_comment", :name => "comment[comment]"
    end
  end
end
