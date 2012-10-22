class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  before_filter :load_config

  def load_config
    if AppConfig.count > 0
      @config = AppConfig.first
    end
  end

  def current_ablity
    current_user.ability
  end
end
