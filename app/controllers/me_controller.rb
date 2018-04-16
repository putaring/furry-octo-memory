class MeController < ApplicationController
  before_action :authenticate!
  before_action :allow_inactive!, only: [:activate, :reactivate]
  before_action :allow_banned!, only: [:banned]
  before_action :allow_active!, only: [:deactivate]
  before_action :allow_unverified!, only: [:verify]

  def show
  end

  def update
    if current_user.update_attributes(user_params)
      head :no_content
    else
      render 'settings/account'
    end
  end

  def reactivate
    current_user.active! and redirect_to user_path(current_user)
  end

  def deactivate
    current_user.inactive! and redirect_to activate_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :birthdate, :password, :password_confirmation, :email,
      :country, :gender, :language, :religion, :height, :status, :sect, :photo_visibility, :income)
  end

  def allow_inactive!
    redirect_to user_path(current_user) unless current_user.inactive?
  end

  def allow_unverified!
    redirect_to user_path(current_user) unless current_user.unverified?
  end

  def allow_banned!
    redirect_to user_path(current_user) unless current_user.banned?
  end

  def allow_active!
    redirect_to user_path(current_user) unless current_user.active?
  end

end
