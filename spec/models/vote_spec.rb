require 'spec_helper'

describe Vote do
  it "should be associated with a proposal" do
    vote = Vote.new
    vote.vote = 'agree'
    vote.user = FactoryGirl.create(:user)
    vote.valid?.should == false

    vote.proposal = FactoryGirl.create(:proposal)
    vote.valid?.should == true
  end

  it "should be associated with a user" do
    vote = Vote.new
    vote.vote = 'agree'
    vote.proposal = FactoryGirl.create(:proposal)
    vote.valid?.should == false

    vote.user = FactoryGirl.create(:user)
    vote.valid?.should == true
  end

  it "should require a comment if the vote is 'disagree'" do
    vote = Vote.new
    vote.vote = 'agree'
    vote.proposal = FactoryGirl.create(:proposal)
    vote.user = FactoryGirl.create(:user)
    vote.vote = 'disagree'
    vote.valid?.should == false

    vote.comment = "this is why"
    vote.valid?.should == true
  end

  it "should only allow certain vote types" do
    vote = FactoryGirl.create(:vote)
    vote.valid?.should == true

    vote.vote = 'agree'
    vote.valid?.should == true
    vote.vote = 'disagree'
    vote.valid?.should == true
    vote.vote = 'abstain'
    vote.valid?.should == true
    vote.vote = 'other'
    vote.valid?.should == false
  end
end
