require 'spec_helper'

describe Committee, type: :model do
  it "must have a name" do
    committee = Committee.new
    expect(committee.valid?).to eq(false)

    committee.name = "Name"
    expect(committee.valid?).to eq(true)
  end

  it "should return it's name as the string" do
    committee = FactoryBot.create(:committee)

    expect(committee.to_s).to eq(committee.name)
  end

  it "should be able to look up related proposals" do
    proposal = FactoryBot.create(:proposal)
    committee = proposal.committee

    expect(committee.proposals).to eq([proposal])
  end

  it "should be able to look up its members" do
    committee_member = FactoryBot.create(:committee_member)
    com = committee_member.committee
    expect(com.committee_members).to eq([committee_member])
  end

  it "should be preliminary by default" do
    committee = Committee.new
    expect(committee.preliminary).to eq(true)
  end

  it "should list the members alphabetically" do
    committee = FactoryBot.create(:committee)
    user_b = FactoryBot.create(:user, name: "Bravo")
    user_a = FactoryBot.create(:user, name: "Alpha")
    user_c = FactoryBot.create(:user, name: "Charlie")
    cm_b = FactoryBot.create(:committee_member, committee: committee, user: user_b)
    cm_a = FactoryBot.create(:committee_member, committee: committee, user: user_a)
    cm_c = FactoryBot.create(:committee_member, committee: committee, user: user_c)

    expect(committee.committee_members).to eq([cm_a, cm_b, cm_c])
  end

  describe "with multiple committees" do
    let!(:base) { FactoryBot.create(:committee, preliminary: false) }
    let!(:prelim2) { FactoryBot.create(:committee, preliminary: true, name: "The Bravo Committee") }
    let!(:prelim1) { FactoryBot.create(:committee, preliminary: true, name: "The Alpha Committee") }
    let(:committees) { Committee.ordered.all }

    it "sorts the base committee first" do
      expect(committees.first).to eq base
    end

    it "sorts the preliminary committees by name" do
      expect(committees).to eq([base, prelim2, prelim1])
    end
  end
end
