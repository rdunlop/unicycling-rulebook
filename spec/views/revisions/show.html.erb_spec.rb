require 'spec_helper'

describe "revisions/show" do
  before(:each) do
    @revision = FactoryGirl.create(:revision)
    @proposal = @revision.proposal
    @discussion = FactoryGirl.create(:discussion, proposal: @proposal)
    @proposal.reload

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders attributes in <p>" do
    render

    rendered.should match(/MyText1/)
    rendered.should match(/Rule Text/)
    rendered.should match(/MyText2/)
    rendered.should match(/MyText3/)
  end
end
