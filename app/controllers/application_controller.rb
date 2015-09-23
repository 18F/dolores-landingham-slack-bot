class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :signed_in?

  before_action :authenticate_user!

  protected

  def signed_in?
    !!session[:token]
  end

  def authenticate_user!
    unless signed_in?
      flash[:error] = 'You need to sign in for access to this page.'
      redirect_to '/auth/myusa'
    end
  end

  def unauthorized
    raise ActionController::RoutingError.new('Unauthorized')
  end

end
