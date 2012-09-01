require 'spec_helper'

describe "votes/edit" do
  before(:each) do
    @vote = assign(:vote, stub_model(Vote,
      :proposal_id => 1,
      :user_id => 1,
      :vote => "MyString"
    ))
  end

  it "renders the edit vote form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => votes_path(@vote), :method => "post" do
      assert_select "input#vote_proposal_id", :name => "vote[proposal_id]"
      assert_select "input#vote_user_id", :name => "vote[user_id]"
      assert_select "input#vote_vote", :name => "vote[vote]"
    end
  end
end
