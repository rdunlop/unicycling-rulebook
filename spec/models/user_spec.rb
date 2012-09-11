require 'spec_helper'

describe User do
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
end
