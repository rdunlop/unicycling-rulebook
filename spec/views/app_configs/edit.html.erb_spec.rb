require 'spec_helper'

describe "app_configs/edit" do
  before(:each) do
    @app_config = assign(:app_config, stub_model(AppConfig,
      :rulebook_name => "MyString",
      :front_page => "MyString",
      :faq => "MyString"
    ))
  end

  it "renders the edit app_config form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => app_configs_path(@app_config), :method => "post" do
      assert_select "input#app_config_rulebook_name", :name => "app_config[rulebook_name]"
      assert_select "textarea#app_config_front_page", :name => "app_config[front_page]"
      assert_select "textarea#app_config_faq", :name => "app_config[faq]"
    end
  end
end
