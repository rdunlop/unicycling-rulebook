require 'spec_helper'

describe Revision, type: :model do
  it "has reference to the proposal" do
    prop = FactoryBot.create(:proposal)
    rev = FactoryBot.create(:revision, proposal: prop)
    expect(rev.proposal).to eq(prop)
  end

  it "has reference to the user" do
    user = FactoryBot.create(:user)
    rev = FactoryBot.create(:revision, user: user)
    expect(rev.user).to eq(user)
  end

  it "must have a body" do
    rev = FactoryBot.create(:revision)
    rev.body = ""
    expect(rev.valid?).to eq(false)

    rev.body = "hi"
    expect(rev.valid?).to eq(true)
  end

  it "must have a change_description for subsequent revisions" do
    rev0 = FactoryBot.create(:revision)
    rev = FactoryBot.create(:revision, proposal: rev0.proposal)
    rev2 = FactoryBot.build(:revision, proposal: rev0.proposal)
    rev2.change_description = ""
    expect(rev2.valid?).to eq(false)

    rev2.change_description = "bye"
    expect(rev2.valid?).to eq(true)
  end
  it "need not have change_description if the proposal is new" do
    prop = FactoryBot.create(:proposal)
    rev = FactoryBot.build(:revision, proposal: prop)
    rev.change_description = ""
    expect(rev.valid?).to eq(true)
  end
  it "should have a num property" do
    prop = FactoryBot.create(:proposal)
    rev = FactoryBot.create(:revision, proposal: prop)
    expect(rev.num).to eq(1)

    prop.reload
    rev2 = FactoryBot.create(:revision, proposal: prop)
    expect(rev2.num).to eq(2)
  end
end
