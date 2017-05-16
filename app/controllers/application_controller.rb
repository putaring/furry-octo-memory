class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :disallow_inactive_users!, unless: :allow_inactive_users?

  def authenticate!
    if current_user.nil?
      if request.xhr?
        head :unauthorized, location: login_path
      else
        redirect_to login_path
      end
    end
  end

  def redirect_if_logged_in!
    redirect_to current_user.admin? ? admin_root_path : user_path(current_user) if logged_in?
  end

  def disallow_inactive_users!
    redirect_to activate_path if current_user && current_user.inactive? && request.path != activate_path
  end

  def allow_inactive_users?
    params[:controller].eql?("sessions") && params[:action].eql?("destroy")
  end
end
