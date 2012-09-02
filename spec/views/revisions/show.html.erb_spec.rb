require 'spec_helper'

describe "revisions/show" do
  before(:each) do
    @revision = assign(:revision, FactoryGirl.create(:revision))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText1/)
    rendered.should match(/MyText2/)
    rendered.should match(/MyText3/)
    rendered.should match(/MyText4/)
  end
end
