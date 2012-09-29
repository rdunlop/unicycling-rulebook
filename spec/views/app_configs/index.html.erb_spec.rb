require 'spec_helper'

describe "app_configs/index" do
  before(:each) do
    assign(:app_configs, [
      stub_model(AppConfig,
        :rulebook_name => "Rulebook Name",
        :front_page => "Front Page",
        :faq => "Faq"
      ),
      stub_model(AppConfig,
        :rulebook_name => "Rulebook Name",
        :front_page => "Front Page",
        :faq => "Faq"
      )
    ])
  end

  it "renders a list of app_configs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Rulebook Name".to_s, :count => 2
    assert_select "tr>td", :text => "Front Page".to_s, :count => 2
    assert_select "tr>td", :text => "Faq".to_s, :count => 2
  end
end
