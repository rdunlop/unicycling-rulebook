require 'spec_helper'

describe "revisions/show", type: :view do
  before(:each) do
    @revision = FactoryGirl.create(:revision)
    @proposal = @revision.proposal
    @discussion = FactoryGirl.create(:discussion, proposal: @proposal)
    @proposal.reload

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
  end

  it "renders attributes in <p>" do
    render

    expect(rendered).to match(/MyText1/)
    expect(rendered).to match(/Rule Text/)
    expect(rendered).to match(/MyText2/)
    expect(rendered).to match(/MyText3/)
  end
end
