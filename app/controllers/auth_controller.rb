class AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:oauth_callback]

  def oauth_callback
    auth = request.env["omniauth.auth"]
    auth_email = auth.extra.raw_info.email

    if is_permitted?(auth_email)
      User.find_or_create_by(email: auth_email)
      session[:token] = auth.credentials.token
      flash[:success] = "You successfully signed in"
      redirect_to root_path
    else
      redirect_to :back
    end
  end

  private

  def is_permitted?(auth_email)
    /#{ENV['AUTH_DOMAIN']}/.match(auth_email)
  end
end
