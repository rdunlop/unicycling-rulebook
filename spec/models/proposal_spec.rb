require 'spec_helper'

describe Proposal do
  it "should have an associated user" do
    user = FactoryGirl.create(:user)
    prop = Proposal.new
    prop.valid?.should == false

    prop.owner = user
    prop.valid?.should == true
  end
end
