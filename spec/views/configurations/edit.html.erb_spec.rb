require 'spec_helper'

describe "configurations/edit", type: :view do
  before(:each) do
    @rulebook = assign(:rulebook, FactoryGirl.build_stubbed(:rulebook,
      rulebook_name: "MyString",
      front_page: "MyString",
      faq: "MyString",
      copyright: "My Copy"))
  end

  it "renders the edit rulebook form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: configuration_path(@rulebook), method: "post" do
      assert_select "input#rulebook_rulebook_name", name: "rulebook[rulebook_name]"
      assert_select "textarea#rulebook_front_page", name: "rulebook[front_page]"
      assert_select "textarea#rulebook_faq", name: "rulebook[faq]"
      assert_select "input#rulebook_copyright", name: "rulebook[copyright]"
    end
  end
end
