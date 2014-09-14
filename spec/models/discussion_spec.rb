require 'spec_helper'

describe Proposal do
  it "should have an associated user" do
    discussion = Discussion.new
    discussion.title = "Hello People"
    discussion.status = "active"
    discussion.valid?.should == false
    discussion.committee = FactoryGirl.create(:committee)

    discussion.owner = FactoryGirl.create(:user)
    discussion.valid?.should == true
  end

  it "must have a title" do
    discussion = Discussion.new
    discussion.status = 'active'
    discussion.owner = FactoryGirl.create(:user)
    discussion.valid?.should == false
    discussion.committee = FactoryGirl.create(:committee)

    discussion.title = "Hi there"
    discussion.valid?.should == true
  end

  it "should have associated comments" do
    discussion = FactoryGirl.create(:discussion)
    comment = FactoryGirl.create(:comment, discussion: discussion)

    discussion.reload.comments.count.should == 1
  end

  it "should order the comments by created date" do
    discussion = FactoryGirl.create(:discussion)
    comment2 = FactoryGirl.create(:comment, discussion: discussion, :created_at => 2.seconds.ago)
    comment3 = FactoryGirl.create(:comment, discussion: discussion, :created_at => 1.second.ago)
    comment1 = FactoryGirl.create(:comment, discussion: discussion, :created_at => 3.seconds.ago)

    discussion.reload.comments.should == [comment1, comment2, comment3]
  end

  describe "when checking the last_update_time" do
    before(:each) do
        @discussion = FactoryGirl.create(:discussion, created_at: 3.days.ago)
    end
    it "describes when the proposal was last revised" do
      @discussion.last_update_time.should == @discussion.created_at
    end
    it "describes when the latest comment was added" do
      @comment = FactoryGirl.create(:comment, discussion: @discussion, :created_at => 30.minutes.ago)
      @comment.reload
      @discussion.last_update_time.should == @comment.created_at
    end
  end
end
