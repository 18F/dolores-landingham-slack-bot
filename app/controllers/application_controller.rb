class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate

  private

  def authenticate
    if Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
      end
    end
  end
end
