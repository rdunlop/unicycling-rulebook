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

  it "should not require a comment" do
    vote = Vote.new
    vote.vote = 'agree'
    vote.proposal = FactoryGirl.create(:proposal)
    vote.user = FactoryGirl.create(:user)
    vote.valid?.should == true

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

  it "should display a summary" do
    date =  DateTime.new(2012, 1, 10, 11, 45, 0, '-6:00')

    user = FactoryGirl.create(:user, :email => 'robin@dunlopweb.com', :name => "Robin Dunlop")
    vote = FactoryGirl.create(:vote, :vote => 'agree', :comment => "my comment", :user => user,
    :created_at => date)
    vote.to_s.should == "Robin Dunlop voted agree on January 10, 2012, 11:45 AM (my comment)"
  end
end
