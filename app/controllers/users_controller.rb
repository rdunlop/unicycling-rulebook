class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user

  # GET /users/:id/edit
  def edit
    authorize @user
  end

  # PUT /users/:id
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

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :location)
  end
end
