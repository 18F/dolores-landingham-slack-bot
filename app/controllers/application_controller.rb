class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?, :signed_in_as_admin?
  before_action :authenticate_user!

  protected

  def current_user_admin
    if !current_user.admin?
      flash[:error] = I18n.t('controllers.application_controller.errors.current_user_admin')
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= find_current_user
  end

  def find_current_user
    if session[:user] && session[:user]["email"]
      User.find_by(email: session[:user]["email"])
    end
  end

  def sign_in(user)
    session[:user] ||= {}
    session[:user]["email"] = user.email
    @current_user = user
  end

  def signout_user!
    session[:user]["email"] = nil
    @current_user = nil
  end

  def signed_in?
    current_user.present?
  end

  def signed_in_as_admin?
    @current_user && @current_user.admin?
  end

  def authenticate_user!
    unless signed_in?
      flash[:error] = I18n.t('application_controller.errors.authenticate_user')
      redirect_to "/session/new"
    end
  end

  def unauthorized
    raise ActionController::RoutingError.new("Unauthorized")
  end

end
