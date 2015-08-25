require 'spec_helper'

describe CommitteeMember, type: :model do
    it "must have a committee" do
        committee_member = CommitteeMember.new
        committee_member.user = FactoryGirl.create(:user)
        expect(committee_member.valid?).to eq(false)

        committee_member.committee = FactoryGirl.create(:committee)
        expect(committee_member.valid?).to eq(true)
    end
    it "must have a user" do
        committee_member = CommitteeMember.new
        committee_member.committee = FactoryGirl.create(:committee)
        expect(committee_member.valid?).to eq(false)

        committee_member.user = FactoryGirl.create(:user)
        expect(committee_member.valid?).to eq(true)
    end
    it "should not be able to add the same committee/user twice" do
        committee_member = FactoryGirl.create(:committee_member)
        committee_member2 = FactoryGirl.build(:committee_member, committee: committee_member.committee,
                                                           user: committee_member.user)
        expect(committee_member2.valid?).to eq(false)
    end
end
