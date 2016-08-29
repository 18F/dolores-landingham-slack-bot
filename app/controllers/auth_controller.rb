class AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:oauth_callback]

  def oauth_callback
    if team_member?
      user = User.find_or_create_by(email: auth_email)
      sign_in(user)
      flash[:success] = I18n.t('controllers.auth_controller.successes.oauth_callback')
      redirect_to root_path
    end
  end

  private

  def team_member?
    auth_hash.credentials.team_member?
  end

  def auth_email
    info.email
  end

  def info
    auth_hash.info
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end
