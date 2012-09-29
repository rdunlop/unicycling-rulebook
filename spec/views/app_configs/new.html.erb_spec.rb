require 'spec_helper'

describe "app_configs/new" do
  before(:each) do
    assign(:app_config, stub_model(AppConfig,
      :rulebook_name => "MyString",
      :front_page => "MyString",
      :faq => "MyString"
    ).as_new_record)
  end

  it "renders new app_config form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => app_configs_path, :method => "post" do
      assert_select "input#app_config_rulebook_name", :name => "app_config[rulebook_name]"
      assert_select "input#app_config_front_page", :name => "app_config[front_page]"
      assert_select "input#app_config_faq", :name => "app_config[faq]"
    end
  end
end
