class AdminUpgradesController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check

  def new
  end

  def create
    raise Pundit::NotAuthorizedError.new("Incorrect Access code") unless params[:access_code] == @config.admin_upgrade_code

    current_user.update_attributes({admin: true})
    flash[:notice] = "Successfully upgraded to admin"
    redirect_to root_path
  end
end
