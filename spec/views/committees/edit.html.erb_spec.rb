require 'spec_helper'

describe "committees/edit", type: :view do
  before(:each) do
    @committee = FactoryBot.create(:committee)
  end

  it "renders the edit committee form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: committee_path(@committee), method: "post" do
      assert_select "input#committee_name", name: "committee[name]"
      assert_select "input#committee_preliminary", name: "committee[preliminary]"
    end
  end
end
