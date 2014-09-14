require 'spec_helper'

describe Comment do
    it "should have an associated discussion" do
        comment = Comment.new
        comment.user = FactoryGirl.create(:user)
        comment.comment = "hi"
        comment.valid?.should == false

        comment.discussion = FactoryGirl.create(:discussion)
        comment.valid?.should == true
    end

    it "should have an associated user" do
        comment = Comment.new
        comment.discussion = FactoryGirl.create(:discussion)
        comment.comment = "hi"
        comment.valid?.should == false

        comment.user = FactoryGirl.create(:user)
        comment.valid?.should == true
    end

    it "should have text in the comment" do
        comment = Comment.new
        comment.discussion = FactoryGirl.create(:discussion)
        comment.user = FactoryGirl.create(:user)
        comment.valid?.should == false

        comment.comment = ""
        comment.valid?.should == false

        comment.comment = "Hello"
        comment.valid?.should == true
    end
end
