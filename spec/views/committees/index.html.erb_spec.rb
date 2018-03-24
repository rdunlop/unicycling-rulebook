require 'spec_helper'

describe "committees/index", type: :view do
  before(:each) do
    @committees = [FactoryBot.create(:committee, preliminary: true),
                   FactoryBot.create(:committee, preliminary: false)]
  end

  it "renders a list of committees" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: @committees.first.name.to_s, count: 1
    assert_select "tr>td", text: 'yes', count: 1
    assert_select "tr>td", text: 'no', count: 1
  end
end
