require 'spec_helper'

describe "revisions/show", type: :view do
  before(:each) do
    @revision = FactoryBot.create(:revision)
    @proposal = @revision.proposal
    @discussion = FactoryBot.create(:discussion, proposal: @proposal)
    @proposal.reload

    allow(view).to receive(:policy).and_return double(create?: false, read_usernames?: false, set_review?: false, revise?: false, vote?: false)
  end

  it "renders attributes in <p>" do
    render

    expect(rendered).to match(/MyText1/)
    expect(rendered).to match(/Rule Text/)
    expect(rendered).to match(/MyText2/)
    expect(rendered).to match(/MyText3/)
  end
end
