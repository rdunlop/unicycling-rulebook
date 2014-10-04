class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :location, :comments]
  end

  public
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  before_filter :load_config

  def load_config
    @config = Rulebook.first || Rulebook.new
  end

  def current_ablity
    current_user.ability
  end

  # breadcrumb methods
  def add_breadcrumb(title, url = nil)
    @breadcrumbs ||= []
    @breadcrumbs << [title, url]
  end

  def render_breadcrumbs
    return if @breadcrumbs.nil?
    res = ""
    @breadcrumbs.each do |br|
      res += "&gt;" unless res.blank?
      res += "<a href='#{br[1]}'>#{br[0]}</a>"
    end
    res.html_safe
  end
  helper_method :render_breadcrumbs

end
