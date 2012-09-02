require 'spec_helper'

describe "proposals/show" do
  before(:each) do
    @proposal = assign(:proposal, FactoryGirl.create(:proposal, :title => "thetitle"))
    @revision = FactoryGirl.create(:revision, :proposal => @proposal, :background => "thebackground")
    @comment = @proposal.comments.new
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/thetitle/)
    rendered.should match(/thebackground/)
  end
end
