require 'spec_helper'

describe "revisions/show" do
  before(:each) do
    @revision = FactoryGirl.create(:revision)
    @proposal = @revision.proposal
    @comment = @proposal.comments.new

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
    # XXX can? nothing: @ability.can :something, @proposal

  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText1/)
    rendered.should match(/MyText2/)
    rendered.should match(/MyText3/)
  end
end
