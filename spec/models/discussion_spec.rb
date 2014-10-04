require 'spec_helper'

describe Proposal, :type => :model do
  it "should have an associated user" do
    discussion = Discussion.new
    discussion.title = "Hello People"
    discussion.status = "active"
    expect(discussion.valid?).to eq(false)
    discussion.committee = FactoryGirl.create(:committee)

    discussion.owner = FactoryGirl.create(:user)
    expect(discussion.valid?).to eq(true)
  end

  it "must have a title" do
    discussion = Discussion.new
    discussion.status = 'active'
    discussion.owner = FactoryGirl.create(:user)
    expect(discussion.valid?).to eq(false)
    discussion.committee = FactoryGirl.create(:committee)

    discussion.title = "Hi there"
    expect(discussion.valid?).to eq(true)
  end

  it "should have associated comments" do
    discussion = FactoryGirl.create(:discussion)
    comment = FactoryGirl.create(:comment, discussion: discussion)

    expect(discussion.reload.comments.count).to eq(1)
  end

  it "should order the comments by created date" do
    discussion = FactoryGirl.create(:discussion)
    comment2 = FactoryGirl.create(:comment, discussion: discussion, :created_at => 2.seconds.ago)
    comment3 = FactoryGirl.create(:comment, discussion: discussion, :created_at => 1.second.ago)
    comment1 = FactoryGirl.create(:comment, discussion: discussion, :created_at => 3.seconds.ago)

    expect(discussion.reload.comments).to eq([comment1, comment2, comment3])
  end
end
