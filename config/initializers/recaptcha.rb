# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.site_key = Rails.configuration.recaptcha_site_key
  config.secret_key = Rails.configuration.recaptcha_secret_key
end
