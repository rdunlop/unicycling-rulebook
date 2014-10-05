class DeviseRulebookMailer < Devise::Mailer
  def self.default_url_options
    super.merge({rulebook_slug: Apartment::Tenant.current})
  end
end
