class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?
  before_action :authenticate_user!

  protected

  def current_user_admin
    if !current_user.admin?
      flash[:error] = "You are not permitted to view that page"
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

  def signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless signed_in?
      flash[:error] = "You need to sign in for access to this page."
      redirect_to "/auth/githubteammember"
    end
  end

  def unauthorized
    raise ActionController::RoutingError.new("Unauthorized")
  end

end
