# https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation
class ConfirmationsController < Devise::ConfirmationsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.
  # skip_before_action :require_no_authentication
  # skip_before_action :authenticate_user!

  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        @confirmable.assign_attributes(update_params) # assign location, name, password, password_confirmation
        @confirmable.confirming = true # cause the name-field to be required
        if @confirmable.valid? and @confirmable.password_match?
          @confirmable.save!
          do_confirm
        else
          do_show
          @confirmable.errors.clear # so that we wont render :new
        end
      else
        @confirmable.errors.add(:email, :password_already_set)
      end
    end

    unless @confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new' # Change this if you don't have the views on default path
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    unless @confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new' # Change this if you don't have the views on default path
    end
  end

  protected

  def update_params
    params.require(:user).permit(:name, :location, :password, :password_confirmation)
  end

  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    @confirmable.only_if_unconfirmed { yield } unless @confirmable.new_record?
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'devise/confirmations/show' # Change this if you don't have the views on default path
  end

  def do_confirm
    @confirmable.confirm
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end
end
