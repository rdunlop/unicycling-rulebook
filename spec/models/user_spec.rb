require 'spec_helper'

describe User, type: :model do
  describe "with an admin user existing" do
    before(:each) do
      @admin = FactoryBot.create(:admin_user)
    end
    it "should have a to: address in new_applicant_email" do
      ActionMailer::Base.deliveries.clear

      user = FactoryBot.create(:user)
      # doesn't send the devise e-mail, because it's already confirmed

      deliveries = ActionMailer::Base.deliveries
      num_deliveries = ActionMailer::Base.deliveries.size

      expect(num_deliveries).to eq(1)

      new_applicant_email = deliveries.last

      expect(new_applicant_email.bcc.count).to eq(1) # sent by after_create hook
      expect(new_applicant_email.bcc).to eq([@admin.email]) # sent by after_create hook
    end
  end

  it "should return it's name as the string" do
    user = FactoryBot.create(:user)

    expect(user.to_s).to eq(user.name)
  end

  it "should be able to get a list of accessible committees" do
    committee = FactoryBot.create(:committee)
    user = FactoryBot.create(:admin_user)
    expect(user.accessible_committees).to eq([committee])
  end

  it "should be able to see its committees" do
    cm = FactoryBot.create(:committee_member)

    expect(cm.user.committees).to eq([cm.committee])
  end

  it "should describe it's voting status via method" do
    user = FactoryBot.create(:user)
    cm = FactoryBot.create(:committee_member, user: user)

    expect(user.voting_text(cm.committee)).to eq("Voting Member")
  end

  it "should describe it's voting status via method when non-voting member" do
    user = FactoryBot.create(:user)
    cm = FactoryBot.create(:committee_member, user: user, voting: false)

    expect(user.voting_text(cm.committee)).to eq("Non-Voting Member")
  end

  it "should be able to list its votes" do
    user = FactoryBot.create(:user)
    vote = FactoryBot.create(:vote, user: user)

    expect(user.votes).to eq([vote])
  end

  it "doesn't need a name initially" do
    u = FactoryBot.build(:user, name: nil, confirmed_at: nil)
    expect(u).to be_valid
  end

  describe "when a user is created without a name" do
    let(:user) { FactoryBot.create(:user, name: nil, confirmed_at: nil, email: "robin@test.com") }

    it "uses the beginning of the e-mail as the to_s" do
      expect(user.to_s).to eq("robin@...")
    end
  end

  it "does require a name after being created" do
    u = FactoryBot.build(:user, name: nil)
    expect(u).to be_invalid
    u.name = "Robin"
    expect(u).to be_valid
  end

  context "with discussion comments" do
    let(:user) { FactoryBot.create(:user) }
    let!(:discussion_comment) { FactoryBot.create(:comment, user: user) }

    it "returns the discussion comments" do
      expect(user.discussion_comments).to match_array([discussion_comment])
    end
  end

  it "should be able to be created with comments" do
    user = User.new({name: "Robin",
                     email: "email@robin.com",
                     password: "password",
                     password_confirmation: "password",
                     comments: "Something"})
    expect(user.comments).to eq("Something")
    expect(user.valid?).to eq(true)
  end

  it "should have no_emails false by default" do
    user = User.new
    expect(user.no_emails).to eq(false)
  end

  it "should be able to be created with no_emails" do
    user = User.new({name: "Robin",
                     email: "email@robin.com",
                     password: "password",
                     password_confirmation: "password",
                     no_emails: true})
    expect(user.no_emails).to eq(true)
    expect(user.valid?).to eq(true)
  end

  context "when a user is not a committee_member" do
    it "can be destroyed" do
      user = FactoryBot.create(:user)
      expect(user.destroy).to be_truthy
    end
  end

  context "when a user is a committee_member" do
    it "cannot be destroyed" do
      user = FactoryBot.create(:user)
      FactoryBot.create(:committee_member, user: user)
      expect(user.destroy).to be_falsy
    end
  end
end
