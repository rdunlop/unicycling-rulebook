require 'spec_helper'

describe AppConfig do
  it "should now allow 2 app configs to exist" do
    FactoryGirl.create(:app_config)
    ac = AppConfig.new
    ac.valid?.should == false
  end
end
