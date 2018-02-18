require 'spec_helper'

describe "rulebooks/show", type: :view do
  before(:each) do
    @rulebook = assign(:rulebook, FactoryBot.build_stubbed(:rulebook,
      rulebook_name: "Rulebook Name",
      front_page: "Front Page",
      faq: "Faq",
      copyright: "Some Copy"))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Rulebook Name/)
    expect(rendered).to match(/Front Page/)
    expect(rendered).to match(/Faq/)
    expect(rendered).to match(/Some Copy/)
  end
end
