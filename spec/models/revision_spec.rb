require 'spec_helper'

describe Revision, type: :model do
    it "has reference to the proposal" do
        prop = FactoryGirl.create(:proposal)
        rev = FactoryGirl.create(:revision, proposal: prop)
        expect(rev.proposal).to eq(prop)
    end

    it "has reference to the user" do
        user = FactoryGirl.create(:user)
        rev = FactoryGirl.create(:revision, user: user)
        expect(rev.user).to eq(user)
    end

    it "must have a body" do
        rev = FactoryGirl.create(:revision)
        rev.body = ""
        expect(rev.valid?).to eq(false)

        rev.body = "hi"
        expect(rev.valid?).to eq(true)
    end

    it "must have a change_description for subsequent revisions" do
        rev0 = FactoryGirl.create(:revision)
        rev = FactoryGirl.create(:revision, proposal: rev0.proposal)
        rev2 = FactoryGirl.build(:revision, proposal: rev0.proposal)
        rev2.change_description = ""
        expect(rev2.valid?).to eq(false)

        rev2.change_description = "bye"
        expect(rev2.valid?).to eq(true)
    end
    it "need not have change_description if the proposal is new" do
        prop = FactoryGirl.create(:proposal)
        rev = FactoryGirl.build(:revision, proposal: prop)
        rev.change_description = ""
        expect(rev.valid?).to eq(true)
    end
    it "should have a num property" do
        prop = FactoryGirl.create(:proposal)
        rev = FactoryGirl.create(:revision, proposal: prop)
        expect(rev.num).to eq(1)

        rev2 = FactoryGirl.create(:revision, proposal: prop)
        expect(rev2.num).to eq(2)
    end
end
