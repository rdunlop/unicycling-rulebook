class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user

  # GET /admin/users/:id/edit
  def edit
    authorize @user
  end

  # PUT /admin/users/:id
  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to membership_committees_path, notice: 'User was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /admin/users/:id
  def destroy
    authorize @user

    if @user.destroy
      flash[:notice] = "User was successfully deleted"
    else
      flash[:alert] = "Unable to delete user (they have committee membership)"
    end
    redirect_back(fallback_location: membership_committees_path)
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :location)
  end
end
