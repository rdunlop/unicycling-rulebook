require 'spec_helper'

describe Proposal do
  it "should have an associated user" do
    prop = Proposal.new
    prop.title = "Hello People"
    prop.valid?.should == false

    prop.owner = FactoryGirl.create(:user)
    prop.valid?.should == true
  end

  it "must have a title" do
    prop = Proposal.new
    prop.owner = FactoryGirl.create(:user)
    prop.valid?.should == false

    prop.title = "Hi there"
    prop.valid?.should == true
  end
end
