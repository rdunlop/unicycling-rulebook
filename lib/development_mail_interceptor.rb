# per http://thepugautomatic.com/2012/08/abort-mail-delivery-with-rails-3-interceptors/

class DevelopmentMailInterceptor
  def self.delivering_email(message)
    Rails.logger.warn "Skipping e-mail delivery in development mode"
    message.perform_deliveries = false
  end
end
