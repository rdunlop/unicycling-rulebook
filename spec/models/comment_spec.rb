require 'spec_helper'

describe Comment, type: :model do
  it "should have an associated discussion" do
    comment = Comment.new
    comment.user = FactoryBot.create(:user)
    comment.comment = "hi"
    expect(comment.valid?).to eq(false)

    comment.discussion = FactoryBot.create(:discussion)
    expect(comment.valid?).to eq(true)
  end

  it "should have an associated user" do
    comment = Comment.new
    comment.discussion = FactoryBot.create(:discussion)
    comment.comment = "hi"
    expect(comment.valid?).to eq(false)

    comment.user = FactoryBot.create(:user)
    expect(comment.valid?).to eq(true)
  end

  it "should have text in the comment" do
    comment = Comment.new
    comment.discussion = FactoryBot.create(:discussion)
    comment.user = FactoryBot.create(:user)
    expect(comment.valid?).to eq(false)

    comment.comment = ""
    expect(comment.valid?).to eq(false)

    comment.comment = "Hello"
    expect(comment.valid?).to eq(true)
  end
end
