require 'spec_helper'

describe "rulebooks/index", type: :view do
  before(:each) do
    assign(:rulebooks, [
             FactoryBot.build_stubbed(:rulebook,
               rulebook_name: "Rulebook Name",
               front_page: "Front Page",
               faq: "Faq",
               copyright: "My Copy")
           ])
  end

  it "renders a list of rulebooks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Rulebook Name".to_s, count: 1
  end
end
