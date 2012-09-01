require 'spec_helper'

describe Comment do
    it "should have an associated proposal" do
        comment = Comment.new
        comment.user = FactoryGirl.create(:user)
        comment.comment = "hi"
        comment.valid?.should == false

        comment.proposal = FactoryGirl.create(:proposal)
        comment.valid?.should == true
    end

    it "should have an associated user" do
        comment = Comment.new
        comment.proposal = FactoryGirl.create(:proposal)
        comment.comment = "hi"
        comment.valid?.should == false

        comment.user = FactoryGirl.create(:user)
        comment.valid?.should == true
    end

    it "should have text in the comment" do
        comment = Comment.new
        comment.proposal = FactoryGirl.create(:proposal)
        comment.user = FactoryGirl.create(:user)
        comment.valid?.should == false

        comment.comment = ""
        comment.valid?.should == false

        comment.comment = "Hello"
        comment.valid?.should == true
    end
end
