require 'spec_helper'

describe Revision do
    it "has reference to the proposal" do
        prop = FactoryGirl.create(:proposal)
        rev = FactoryGirl.create(:revision, :proposal => prop)
        rev.proposal.should == prop
    end

    it "has reference to the user" do
        user = FactoryGirl.create(:user)
        rev = FactoryGirl.create(:revision, :user => user)
        rev.user.should == user
    end

    it "must have a body" do
        rev = FactoryGirl.create(:revision)
        rev.body = ""
        rev.valid?.should == false

        rev.body = "hi"
        rev.valid?.should == true
    end

    it "must have a change_description" do
        rev0 = FactoryGirl.create(:revision)
        rev = FactoryGirl.create(:revision, :proposal => rev0.proposal)
        rev.change_description = ""
        rev.valid?.should == false

        rev.change_description = "bye"
        rev.valid?.should == true
    end
    it "need not have change_description if the proposal is new" do
        rev = FactoryGirl.create(:revision)
        rev.change_description = ""
        rev.valid?.should == true
    end
end
