Mailjet.configure do |config|
  config.api_key = Rails.configuration.mailjet_api_key
  config.secret_key = Rails.configuration.mailjet_secret_key
  config.default_from = Rails.configuration.mailjet_default_from
end
