require 'spec_helper'

describe Committee do
    it "must have a name" do
        committee = Committee.new
        committee.valid?.should == false

        committee.name = "Name"
        committee.valid?.should == true
    end

    it "should return it's name as the string" do
        committee = FactoryGirl.create(:committee)

        committee.to_s.should == committee.name
    end

    it "should be able to look up related proposals" do
        proposal = FactoryGirl.create(:proposal)
        committee = proposal.committee

        committee.proposals.should == [proposal]
    end

    it "should be able to look up its members" do
        committee_member = FactoryGirl.create(:committee_member)
        com = committee_member.committee
        com.committee_members.should == [committee_member]
    end

    it "should be non-preliminary by default" do
        committee = Committee.new
        committee.preliminary.should == false
    end
    it "should list the members alphabetically" do
      committee = FactoryGirl.create(:committee)
      user_b = FactoryGirl.create(:user, :name => "Bravo")
      user_a = FactoryGirl.create(:user, :name => "Alpha")
      user_c = FactoryGirl.create(:user, :name => "Charlie")
      cm_b = FactoryGirl.create(:committee_member, :committee => committee, :user => user_b)
      cm_a = FactoryGirl.create(:committee_member, :committee => committee, :user => user_a)
      cm_c = FactoryGirl.create(:committee_member, :committee => committee, :user => user_c)

      committee.committee_members.should == [cm_a, cm_b, cm_c]
    end
end
