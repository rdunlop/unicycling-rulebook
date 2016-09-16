require 'spec_helper'

describe "rulebooks/new", type: :view do
  before(:each) do
    assign(:rulebook, FactoryGirl.build_stubbed(:rulebook,
      rulebook_name: "MyString",
      front_page: "MyString",
      faq: "MyString",
      copyright: "Robin Copy"))
  end

  it "renders new rulebook form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: rulebooks_path, method: "post" do
      assert_select "input#rulebook_rulebook_name", name: "rulebook[rulebook_name]"
      assert_select "textarea#rulebook_front_page", name: "rulebook[front_page]"
      assert_select "textarea#rulebook_faq", name: "rulebook[faq]"
      assert_select "input#rulebook_copyright", name: "rulebook[copyright]"
    end
  end
end
