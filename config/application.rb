require_relative "boot"

require "rails/all"
require "apartment/custom_console"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RulebookApp
  class Application < Rails::Application
    config.load_defaults '5.2'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # In order for Devise to send e-mail asynchronously, we have to
    # configure an ActiveJob queue Adapter
    config.active_job.queue_adapter = :sidekiq

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql
    config.action_dispatch.rescue_responses['Errors::TenantNotFound'] = :not_found

    # Enable the asset pipeline
    config.assets.enabled = true

    config.active_record.belongs_to_required_by_default = true

    config.assets.initialize_on_precompile = false

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.tinymce.install = :compile

    # ENV variables
    config.secret_key_base = ENV["SECRET_KEY_BASE"]
    config.secret = ENV["SECRET"]

    config.domain = ENV["DOMAIN"]
    config.ssl_enabled = ENV["SSL_ENABLED"].to_s == "true"
    config.rulebook_creation_access_code = ENV["RULEBOOK_CREATION_ACCESS_CODE"]
    config.mail_server = ENV["MAIL_SERVER"]
    config.mail_port = ENV["MAIL_PORT"]
    config.mail_domain = ENV["MAIL_DOMAIN"]
    config.mail_username = ENV["MAIL_USERNAME"]
    config.mail_password = ENV["MAIL_PASSWORD"]
    config.mail_full_email = ENV["MAIL_FULL_EMAIL"]
    config.mail_authentication = ENV["MAIL_AUTHENTICATION"]
    config.mail_tls = ENV["MAIL_TLS"].to_s == "true"
    config.mail_from_name = ENV["MAIL_FROM_NAME"]
    config.rollbar_access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
    config.google_analytics_tracking_id = ENV["GOOGLE_ANALYTICS_TRACKING_ID"]
    config.google_analytics_4_tracking_id = ENV["GOOGLE_ANALYTICS_4_TRACKING_ID"]

    config.redis_host = ENV["REDIS_HOST"]
    config.redis_port = ENV["REDIS_PORT"]
    config.redis_db = ENV["REDIS_DB"]
    config.recaptcha_site_key = ENV["RECAPTCHA_SITE_KEY"]
    config.recaptcha_secret_key = ENV["RECAPTCHA_SECRET_KEY"]

    config.aws_region = ENV["AWS_REGION"]
    config.aws_bucket = ENV["AWS_BUCKET"]
    config.aws_access_key = ENV["AWS_ACCESS_KEY"]
    config.aws_secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]

    config.mailjet_api_key = ENV["MAILJET_API_KEY"]
    config.mailjet_secret_key = ENV["MAILJET_SECRET_KEY"]
    config.mailjet_default_from = ENV["MAILJET_DEFAULT_FROM"]
  end
end
