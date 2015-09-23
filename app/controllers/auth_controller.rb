class AuthController < ApplicationController
  skip_before_action :authenticate_user!

  def oauth_callback
    auth = request.env['omniauth.auth']

    auth_email = auth.extra.raw_info.email
    is_gsa = /gsa.gov/.match(auth_email)
    
    if !is_gsa
      unauthorized
    else
      session[:token] = auth.credentials.token
      flash[:success] = "You successfully signed in"
      redirect_to root_path
    end
  end
end
