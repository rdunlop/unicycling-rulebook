class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout "rulebook"
  before_action :load_config
  before_action :set_base_breadcrumb

  after_action :verify_authorized, unless: :devise_controller?

  force_ssl if: :ssl_configured?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :location, :comments])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :location, :comments, :no_emails])
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

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end

  def load_config
    @config = Rulebook.current_rulebook

    # if there is no subdomain specified, redirect to the 'choose-subdomain' page
    if @config.nil? && !(controller_name == "welcome" && (action_name == "index_all" || action_name == "new_location"))
      redirect_to welcome_index_all_path, flash: { alert: "Invalid subdomain" }
    end
  end

  def set_base_breadcrumb
    add_breadcrumb @config.rulebook_name, root_url if @config
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

  # Internal: Is SSL configured?
  #
  # Returns a boolean.
  def ssl_configured?
    !Rails.env.development?
  end
end
