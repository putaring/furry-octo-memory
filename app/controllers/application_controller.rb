class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include AvatarHelper

  before_action :disallow_inactive_users!, except: [:activate, :reactivate], unless: :public_pages?
  before_action :disallow_banned_users!, except: :banned, unless: :public_pages?
  before_action :disallow_unverified_users!, except: :verify, unless: :public_pages?


  def redirect_if_logged_in!
    redirect_to current_user.admin? ? admin_root_path : user_path(current_user) if logged_in?
  end

  def disallow_inactive_users!
    redirect_to activate_path if logged_in? && current_user.inactive?
  end

  def disallow_banned_users!
    redirect_to banned_path if logged_in? && current_user.banned?
  end

  def disallow_unverified_users!
    redirect_to verify_path if logged_in? && current_user.unverified?
  end

  def public_pages?
    (params[:controller].eql?("sessions") && params[:action].eql?("destroy")) || params[:controller].eql?("static_pages")
  end
end
