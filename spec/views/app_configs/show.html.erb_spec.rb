require 'spec_helper'

describe "app_configs/show" do
  before(:each) do
    @app_config = assign(:app_config, FactoryGirl.build_stubbed(:app_config,
      :rulebook_name => "Rulebook Name",
      :front_page => "Front Page",
      :faq => "Faq",
      :copyright => "Some Copy"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Rulebook Name/)
    rendered.should match(/Front Page/)
    rendered.should match(/Faq/)
    rendered.should match(/Some Copy/)
  end
end
