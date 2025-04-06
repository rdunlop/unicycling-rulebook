ActionMailer::Base.default from: Rails.configuration.mail_full_email

ActionMailer::Base.default_url_options[:host] = Rails.configuration.domain

unless Rails.env.test?
  if Rails.configuration.mailjet_api_key.present?
    ActionMailer::Base.delivery_method = :mailjet
  elsif Rails.configuration.aws_access_key.present?
    ActionMailer::Base.delivery_method = :aws_sdk
  else
    ActionMailer::Base.smtp_settings = {
      address: Rails.configuration.mail_server,
      port: Rails.configuration.mail_port,
      domain: Rails.configuration.mail_domain,
      user_name: Rails.configuration.mail_username,
      password: Rails.configuration.mail_password,
      authentication: Rails.configuration.mail_authentication,
      enable_starttls_auto: (Rails.configuration.mail_tls.to_s == 'true')
    }
    ActionMailer::Base.delivery_method = :smtp
  end
end

require 'logging_mail_interceptor'
require 'development_mail_interceptor'
ActionMailer::Base.register_interceptor(LoggingMailInterceptor)
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
