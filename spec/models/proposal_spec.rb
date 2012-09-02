require 'spec_helper'

describe Proposal do
  it "should have an associated user" do
    prop = Proposal.new
    prop.committee = FactoryGirl.create(:committee)
    prop.title = "Hello People"
    prop.valid?.should == false

    prop.owner = FactoryGirl.create(:user)
    prop.valid?.should == true
  end

  it "must have a title" do
    prop = Proposal.new
    prop.owner = FactoryGirl.create(:user)
    prop.committee = FactoryGirl.create(:committee)
    prop.valid?.should == false

    prop.title = "Hi there"
    prop.valid?.should == true
  end

  it "should have an associated committee" do
    prop = Proposal.new
    prop.title = "Hello People"
    prop.owner = FactoryGirl.create(:user)
    prop.valid?.should == false

    prop.committee = FactoryGirl.create(:committee)
    prop.valid?.should == true
  end

  it "should return its title as the default string" do
    prop = FactoryGirl.create(:proposal)

    prop.to_s.should == prop.title
  end

  it "should have associated votes" do
    proposal = FactoryGirl.create(:proposal)
    vote = FactoryGirl.create(:vote, :proposal => proposal)

    prop = Proposal.find(proposal.id)

    prop.votes.count.should == 1
  end

  it "should have associated comments" do
    proposal = FactoryGirl.create(:proposal)
    vote = FactoryGirl.create(:comment, :proposal => proposal)

    prop = Proposal.find(proposal.id)

    prop.comments.count.should == 1
  end
end
