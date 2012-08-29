require 'spec_helper'

describe Committee do
    it "must have a name" do
        committee = Committee.new
        committee.valid?.should == false

        committee.name = "Name"
        committee.valid?.should == true
    end
end
