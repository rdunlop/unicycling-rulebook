require 'spec_helper'

describe "welcome/index", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    @config = AppConfig.new
  end


  it "renders a list of committees" do
    @committee1 = FactoryGirl.create(:committee)
    @committees = [@committee1]
    render
    expect(rendered).to match(/#{@committee1.name}/)
  end
end
