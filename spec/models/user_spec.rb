require 'spec_helper'

describe User do

    it "sends an e-mail when a new user is created" do
        ActionMailer::Base.deliveries.clear
        user = FactoryGirl.create(:user, :confirmed_at => nil)
        user.confirm!
        num_deliveries = ActionMailer::Base.deliveries.size
        # Note: devise sends a confirmation e-mail,
        # without having an admin user in the system, it will not send one there too.

        deliveries = ActionMailer::Base.deliveries
        num_deliveries = ActionMailer::Base.deliveries.size

        num_deliveries.should == 1
        sign_up_email = deliveries.first
        sign_up_email.to.count.should == 1 # sent by devise
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

            num_deliveries.should == 1

            new_applicant_email = deliveries.last

            new_applicant_email.bcc.count.should == 1 # sent by after_create hook
            new_applicant_email.bcc.should == [@admin.email] # sent by after_create hook
        end
    end

    it "should require a name" do
        user = FactoryGirl.create(:user)

        user.name = ""
        user.valid?.should == false
    end

    it "should return it's name as the string" do
        user = FactoryGirl.create(:user)

        user.to_s.should == user.name
    end
    it "should be able to get a list of accessible committees" do
      committee = FactoryGirl.create(:committee)
      user = FactoryGirl.create(:admin_user)
      user.accessible_committees.should == [committee]
    end

    it "should be able to see its committees" do
        cm = FactoryGirl.create(:committee_member)

        cm.user.committees.should == [cm.committee]
    end

    it "should describe it's voting status via method" do
        user = FactoryGirl.create(:user)
        cm = FactoryGirl.create(:committee_member, :user => user)

        user.voting_text(cm.committee).should == "Voting Member"
    end

    it "should describe it's voting status via method when non-voting member" do
        user = FactoryGirl.create(:user)
        cm = FactoryGirl.create(:committee_member, :user => user, :voting => false)

        user.voting_text(cm.committee).should == "Non-Voting Member"
    end
    it "should be able to list its votes" do
        user = FactoryGirl.create(:user)
        vote = FactoryGirl.create(:vote, :user => user)

        user.votes.should == [vote]
    end
    it "should be able to be created with comments" do
        user = User.new({:name => "Robin", 
                         :email => "email@robin.com", 
                         :password => "password", 
                         :password_confirmation => "password", 
                         :comments => "Something"})
        user.comments.should == "Something"
        user.valid?.should == true
    end
    it "should have no_emails false by default" do
        user = User.new
        user.no_emails.should == false
    end
    it "should be able to be created with no_emails" do
        user = User.new({:name => "Robin", 
                         :email => "email@robin.com", 
                         :password => "password", 
                         :password_confirmation => "password", 
                         :no_emails => true})
        user.no_emails.should == true
        user.valid?.should == true
    end
end
