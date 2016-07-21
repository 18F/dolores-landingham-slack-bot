class UsersController < ApplicationController
  before_action :current_user_admin, only: [:edit, :update]

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = "User updated successfully"
      redirect_to employees_path
    end
  end

  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:admin)
  end
end
