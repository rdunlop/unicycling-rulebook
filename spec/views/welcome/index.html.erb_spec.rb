require 'spec_helper'

describe "welcome/index", type: :view do
  before(:each) do
    @config = Rulebook.new
  end


  it "renders a list of committees" do
    @committee1 = FactoryBot.create(:committee)
    @committees = [@committee1]
    render
    expect(rendered).to match(/#{@committee1.name}/)
  end
end
