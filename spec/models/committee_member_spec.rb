require 'spec_helper'

describe CommitteeMember do
    it "must have a committee" do
        committee_member = CommitteeMember.new
        committee_member.user = FactoryGirl.create(:user)
        committee_member.valid?.should == false

        committee_member.committee = FactoryGirl.create(:committee)
        committee_member.valid?.should == true
    end
    it "must have a user" do
        committee_member = CommitteeMember.new
        committee_member.committee = FactoryGirl.create(:committee)
        committee_member.valid?.should == false

        committee_member.user = FactoryGirl.create(:user)
        committee_member.valid?.should == true
    end
end
