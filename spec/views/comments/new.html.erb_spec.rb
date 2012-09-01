require 'spec_helper'

describe "comments/new" do
  before(:each) do
    assign(:comment, stub_model(Comment,
      :proposal_id => 1,
      :user_id => 1,
      :comment => "MyText"
    ).as_new_record)
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path, :method => "post" do
      assert_select "input#comment_proposal_id", :name => "comment[proposal_id]"
      assert_select "input#comment_user_id", :name => "comment[user_id]"
      assert_select "textarea#comment_comment", :name => "comment[comment]"
    end
  end
end
