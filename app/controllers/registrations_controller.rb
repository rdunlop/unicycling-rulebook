# https://github.com/heartcombo/devise/wiki/How-To:-Use-Recaptcha-with-Devise#add-recaptcha-verification-in-controllers
class RegistrationsController < Devise::RegistrationsController
  before_action :check_captcha, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter

  def check_captcha
    return if Rails.application.secrets.recaptcha_site_key.blank?
    return if verify_recaptcha(action: 'signup')

    self.resource = resource_class.new sign_up_params
    resource.validate # Look for any other validation errors besides reCAPTCHA
    set_minimum_password_length

    respond_with_navigational(resource) do
      flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
      render :new
    end
  end
end
