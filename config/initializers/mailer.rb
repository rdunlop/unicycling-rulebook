ActionMailer::Base.default :from => Rails.application.secrets.mail_full_email

ActionMailer::Base.default_url_options[:host] = Rails.application.secrets.domain

unless Rails.env.test?
  if Rails.application.secrets.mailjet_api_key.present?
    ActionMailer::Base.delivery_method = :mailjet
  elsif Rails.application.secrets.aws_access_key.present?
    ActionMailer::Base.delivery_method = :amazon_ses
  else
    ActionMailer::Base.smtp_settings = {
      address:              Rails.application.secrets.mail_server,
      port:                 Rails.application.secrets.mail_port,
      domain:               Rails.application.secrets.mail_domain,
      user_name:            Rails.application.secrets.mail_username,
      password:             Rails.application.secrets.mail_password,
      authentication:       Rails.application.secrets.mail_authentication,
      enable_starttls_auto: (Rails.application.secrets.mail_tls.to_s == 'true')
    }
    ActionMailer::Base.delivery_method = :smtp
  end
end

require 'logging_mail_interceptor'
require 'development_mail_interceptor'
ActionMailer::Base.register_interceptor(LoggingMailInterceptor)
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
