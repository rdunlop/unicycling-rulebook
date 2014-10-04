require 'spec_helper'

describe "committees/new", :type => :view do
  before(:each) do
    @committee = assign(:committee, FactoryGirl.create(:committee))
  end

  it "renders new committee form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => new_committee_path, :method => "post" do
      assert_select "input#committee_name", :name => "committee[name]"
      assert_select "input#committee_preliminary", :name => "committee[preliminary]"
    end
  end
end
