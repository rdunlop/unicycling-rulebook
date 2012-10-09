require 'spec_helper'

describe "app_configs/index" do
  before(:each) do
    assign(:app_configs, [
      stub_model(AppConfig,
        :rulebook_name => "Rulebook Name",
        :front_page => "Front Page",
        :faq => "Faq",
        :copyright => "My Copy"
      )
    ])
  end

  it "renders a list of app_configs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Rulebook Name".to_s, :count => 1
    assert_select "tr>td", :text => "Front Page".to_s, :count => 1
    assert_select "tr>td", :text => "Faq".to_s, :count => 1
    assert_select "tr>td", :text => "My Copy".to_s, :count => 1
  end
end
