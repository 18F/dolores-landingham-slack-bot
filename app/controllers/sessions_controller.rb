class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
  end

  def destroy
    signout_user!
    redirect_to new_session_url
  end

  def create
  end
end
