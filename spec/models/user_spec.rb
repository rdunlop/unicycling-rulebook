require 'spec_helper'

describe User do
    it "should return it's email as the string" do
        user = FactoryGirl.create(:user)

        user.to_s.should == user.email
    end
end
