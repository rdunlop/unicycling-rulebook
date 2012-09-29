require 'spec_helper'

describe "app_configs/show" do
  before(:each) do
    @app_config = assign(:app_config, stub_model(AppConfig,
      :rulebook_name => "Rulebook Name",
      :front_page => "Front Page",
      :faq => "Faq"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Rulebook Name/)
    rendered.should match(/Front Page/)
    rendered.should match(/Faq/)
  end
end
