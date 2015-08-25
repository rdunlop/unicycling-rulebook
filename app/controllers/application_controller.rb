class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout "rulebook"
  before_filter :load_config
  before_action :set_base_breadcrumb

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :location, :comments]
    devise_parameter_sanitizer.for(:account_update) << [:name, :location, :comments, :no_emails]
  end

  # Prevent stored_location_for redirecting to a different tenant
  def after_sign_in_path_for(resource)
    location = stored_location_for(resource)
    if location && location.starts_with?("/r/#{Apartment::Tenant.current}")
      location
    else
      root_path
    end
  end

  private

  rescue_from CanCan::AccessDenied do |exception|
    if Apartment::Tenant.current
      redirect_to root_path, alert: exception.message
    else
      redirect_to welcome_index_all_path, :alert => exception.message
    end
  end


  def load_config
    @config = self.class.get_current_config
  end

  def set_base_breadcrumb
    add_breadcrumb @config.rulebook_name, root_url if @config
  end

  def self.get_current_config
    Rulebook.current_rulebook
  end

  def current_ablity
    current_user.ability
  end

  def set_committee_breadcrumb(committee = @committee)
    add_breadcrumb "Committee: #{committee.name}", committee_path(committee)
  end

  def set_proposal_breadcrumb(proposal = @proposal)
    set_committee_breadcrumb(proposal.committee)
    add_breadcrumb "Proposal: #{proposal.title}", proposal_path(proposal)
  end
end
