require 'spec_helper'

describe Vote, :type => :model do
  it "should be associated with a proposal" do
    vote = Vote.new
    vote.vote = 'agree'
    vote.user = FactoryGirl.create(:user)
    expect(vote.valid?).to eq(false)

    vote.proposal = FactoryGirl.create(:proposal)
    expect(vote.valid?).to eq(true)
  end

  it "should be associated with a user" do
    vote = Vote.new
    vote.vote = 'agree'
    vote.proposal = FactoryGirl.create(:proposal)
    expect(vote.valid?).to eq(false)

    vote.user = FactoryGirl.create(:user)
    expect(vote.valid?).to eq(true)
  end

  it "should not require a comment" do
    vote = Vote.new
    vote.vote = 'agree'
    vote.proposal = FactoryGirl.create(:proposal)
    vote.user = FactoryGirl.create(:user)
    expect(vote.valid?).to eq(true)

    vote.comment = "this is why"
    expect(vote.valid?).to eq(true)
  end

  it "should only allow certain vote types" do
    vote = FactoryGirl.create(:vote)
    expect(vote.valid?).to eq(true)

    vote.vote = 'agree'
    expect(vote.valid?).to eq(true)
    vote.vote = 'disagree'
    expect(vote.valid?).to eq(true)
    vote.vote = 'abstain'
    expect(vote.valid?).to eq(true)
    vote.vote = 'other'
    expect(vote.valid?).to eq(false)
  end

  it "should display a summary" do
    date =  DateTime.new(2012, 1, 10, 11, 45, 0, '-6:00')

    user = FactoryGirl.create(:user, :email => 'robin@dunlopweb.com', :name => "Robin Dunlop")
    vote = FactoryGirl.create(:vote, :vote => 'agree', :comment => "my comment", :user => user,
    :created_at => date)
    expect(vote.to_s).to eq("Robin Dunlop voted agree on January 10, 2012, 11:45 AM (my comment)")
  end
  it "can't vote twice on the same proposal by the same user" do
    @vote1 = FactoryGirl.create(:vote)
    @vote2 = FactoryGirl.build(:vote, :proposal => @vote1.proposal, :user => @vote1.user)
    expect(@vote2.valid?).to eq(false)
  end
  it "can vote on the same proposal with 2 people" do
    @vote1 = FactoryGirl.create(:vote)
    @vote2 = FactoryGirl.build(:vote, :proposal => @vote1.proposal) # new user
    expect(@vote2.valid?).to eq(true)
  end
end
