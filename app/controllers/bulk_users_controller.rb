class BulkUsersController < ApplicationController
  before_action :authenticate_ability
  before_action :authenticate_user!

  def index
    add_breadcrumb "Bulk User Creation"
  end

  def create
    good_emails = []
    bad_emails = []

    params[:new_users][:emails].split(", ").each do |email|
      user = User.new(email: email)

      if user.save
        good_emails << email
      else
        bad_emails << email
      end
    end

    flash[:notice] = "Created user accounts for #{good_emails.join(', ')}" if good_emails.any?
    flash[:alert] = "Errors #{bad_emails.join(', ')}" if bad_emails.any?
    redirect_to bulk_users_path
  end

  private

  def authenticate_ability
    authorize :bulk_users, :create?
  end
end
