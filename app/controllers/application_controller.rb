class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def authenticate!
    redirect_to login_path if current_user.nil?
  end

  def redirect_if_logged_in!
    redirect_to me_path if logged_in?
  end
end
