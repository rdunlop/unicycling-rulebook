require 'spec_helper'

describe "comments/show" do
  before(:each) do
    @comment = assign(:comment, FactoryGirl.create(:comment, :comment => "hi"))
    @proposal = @comment.proposal
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/hi/)
  end
end
