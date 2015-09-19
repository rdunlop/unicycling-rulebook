class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout "rulebook"
  before_filter :load_config
  before_action :set_base_breadcrumb

  after_action :verify_authorized, unless: :devise_controller?

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

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def load_config
    @config = Rulebook.current_rulebook

    # if there is no subdomain specified, redirect to the 'choose-subdomain' page
    if @config.nil? && !(controller_name == "welcome" && action_name == "index_all")
      redirect_to welcome_index_all_path
    end
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
