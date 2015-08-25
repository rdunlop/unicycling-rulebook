require 'spec_helper'

describe Comment, type: :model do
    it "should have an associated discussion" do
        comment = Comment.new
        comment.user = FactoryGirl.create(:user)
        comment.comment = "hi"
        expect(comment.valid?).to eq(false)

        comment.discussion = FactoryGirl.create(:discussion)
        expect(comment.valid?).to eq(true)
    end

    it "should have an associated user" do
        comment = Comment.new
        comment.discussion = FactoryGirl.create(:discussion)
        comment.comment = "hi"
        expect(comment.valid?).to eq(false)

        comment.user = FactoryGirl.create(:user)
        expect(comment.valid?).to eq(true)
    end

    it "should have text in the comment" do
        comment = Comment.new
        comment.discussion = FactoryGirl.create(:discussion)
        comment.user = FactoryGirl.create(:user)
        expect(comment.valid?).to eq(false)

        comment.comment = ""
        expect(comment.valid?).to eq(false)

        comment.comment = "Hello"
        expect(comment.valid?).to eq(true)
    end
end
