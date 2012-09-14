require 'spec_helper'

describe User do

    it "sends an e-mail when a new user is created" do
        ActionMailer::Base.deliveries.clear
        user = FactoryGirl.create(:user)
        num_deliveries = ActionMailer::Base.deliveries.size
        # Note: devise sends a confirmation e-mail, I ALSO want
        # one sent to the admins
        num_deliveries.should == 2
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
        user = User.new({:name => "Robin", :email => "email@robin.com", :password => "password", :password_confirmation => "password", :comments => "Something"})
        user.comments.should == "Something"
        user.valid?.should == true
    end
end
