class LoggingMailInterceptor
  def self.delivering_email(message)
    Rails.logger.warn "sending message subject: #{message.subject}"
    Rails.logger.warn "to #{message.to}"
    Rails.logger.warn "cc #{message.cc}"
    Rails.logger.warn "bcc #{message.bcc}"
  end
end
