class MeController < ApplicationController
  before_action :authenticate!

  def show
  end

  def update
    if current_user.update_attributes(user_params)
      head :no_content
    else
      render json: current_user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:username, :birthdate, :password, :email,
      :country, :gender, :language, :religion)
  end
end
