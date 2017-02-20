class MeController < ApplicationController
  before_action :authenticate!
  before_action :allow_inactive!, only: [:activate, :reactivate]

  def show
  end

  def update
    if current_user.update_attributes(user_params)
      head :no_content
    else
      render json: current_user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def reactivate
    current_user.active! and redirect_to me_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :birthdate, :password, :password_confirmation, :email,
      :country, :gender, :language, :religion, :height, :status, :sect, :photo_visibility)
  end

  def allow_inactive!
    redirect_to me_path if current_user && !current_user.inactive?
  end
end
