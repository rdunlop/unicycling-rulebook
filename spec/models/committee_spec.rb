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
end
