require 'spec_helper'

describe User, :type => :model do

    it "sends an e-mail when a new user is created" do
        ActionMailer::Base.deliveries.clear
        user = FactoryGirl.create(:user, :confirmed_at => nil)
        user.confirm!
        num_deliveries = ActionMailer::Base.deliveries.size
        # Note: devise sends a confirmation e-mail,
        # without having an admin user in the system, it will not send one there too.

        deliveries = ActionMailer::Base.deliveries
        num_deliveries = ActionMailer::Base.deliveries.size

        expect(num_deliveries).to eq(1)
        sign_up_email = deliveries.first
        expect(sign_up_email.to.count).to eq(1) # sent by devise
    end

    describe "with an admin user existing" do
        before(:each) do
            @admin = FactoryGirl.create(:admin_user)
        end
        it "should have a to: address in new_applicant_email" do

            ActionMailer::Base.deliveries.clear

            user = FactoryGirl.create(:user)
            # doesn't send the devise e-mail, because it's already confirmed

            deliveries = ActionMailer::Base.deliveries
            num_deliveries = ActionMailer::Base.deliveries.size

            expect(num_deliveries).to eq(1)

            new_applicant_email = deliveries.last

            expect(new_applicant_email.bcc.count).to eq(1) # sent by after_create hook
            expect(new_applicant_email.bcc).to eq([@admin.email]) # sent by after_create hook
        end
    end

    it "should require a name" do
        user = FactoryGirl.create(:user)

        user.name = ""
        expect(user.valid?).to eq(false)
    end

    it "should return it's name as the string" do
        user = FactoryGirl.create(:user)

        expect(user.to_s).to eq(user.name)
    end
    it "should be able to get a list of accessible committees" do
      committee = FactoryGirl.create(:committee)
      user = FactoryGirl.create(:admin_user)
      expect(user.accessible_committees).to eq([committee])
    end

    it "should be able to see its committees" do
        cm = FactoryGirl.create(:committee_member)

        expect(cm.user.committees).to eq([cm.committee])
    end

    it "should describe it's voting status via method" do
        user = FactoryGirl.create(:user)
        cm = FactoryGirl.create(:committee_member, :user => user)

        expect(user.voting_text(cm.committee)).to eq("Voting Member")
    end

    it "should describe it's voting status via method when non-voting member" do
        user = FactoryGirl.create(:user)
        cm = FactoryGirl.create(:committee_member, :user => user, :voting => false)

        expect(user.voting_text(cm.committee)).to eq("Non-Voting Member")
    end
    it "should be able to list its votes" do
        user = FactoryGirl.create(:user)
        vote = FactoryGirl.create(:vote, :user => user)

        expect(user.votes).to eq([vote])
    end
    it "should be able to be created with comments" do
        user = User.new({:name => "Robin", 
                         :email => "email@robin.com", 
                         :password => "password", 
                         :password_confirmation => "password", 
                         :comments => "Something"})
        expect(user.comments).to eq("Something")
        expect(user.valid?).to eq(true)
    end
    it "should have no_emails false by default" do
        user = User.new
        expect(user.no_emails).to eq(false)
    end
    it "should be able to be created with no_emails" do
        user = User.new({:name => "Robin", 
                         :email => "email@robin.com", 
                         :password => "password", 
                         :password_confirmation => "password", 
                         :no_emails => true})
        expect(user.no_emails).to eq(true)
        expect(user.valid?).to eq(true)
    end
end
