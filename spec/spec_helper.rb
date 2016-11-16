# run coverage when on CI
if ENV['CI']
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter '/spec/'
  end
end

ENV["RAILS_ENV"] ||= 'test'

# This file is copied to spec/ when you run 'rails generate rspec:install'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "pundit/rspec"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:each, type: :view) {
    controller.default_url_options[:rulebook_slug] = "test_rulebook"
  }

  config.infer_spec_type_from_file_location!

  # Default to using inline, meaning all jobs will run as they're
  # called. Since we primarily are using this for email, this ensures
  # the emails go immediately to ActionMailer::Base.deliveries
  require 'sidekiq/testing'
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end

  # In order to cause .deliver_later to actually .deliver_now
  config.before(:each) do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true
  end

  config.before(:each) do
    rulebook = FactoryGirl.create(:rulebook, :test_schema)
    Apartment::Tenant.switch! rulebook.subdomain
  end

  config.before(:each, type: :controller) do
    request.env['HTTPS'] = 'on'
  end

  config.around(:each) do |example|
    if example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!(&example)
    else
      Sidekiq::Testing.inline!(&example)
    end
  end
end
