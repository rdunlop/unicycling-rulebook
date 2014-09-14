require 'spec_helper'

describe "welcome/index" do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end


  it "renders a list of committees" do
    @committee1 = FactoryGirl.create(:committee)
    @committees = [@committee1]
    render
    rendered.should match(/#{@committee1.name}/)
  end
end
