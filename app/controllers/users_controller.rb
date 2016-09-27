class UsersController < ApplicationController

  before_action :redirect_if_logged_in!, only: [:new, :create]
  before_action :authenticate!, only: [:like, :unlike, :update]
  before_action :authorize!, only: [:update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to me_path
      # onboarding_about_path
    else
      render 'new'
    end
  end

  def update
    if current_user.update_attributes(user_params)
      head :no_content
    else
      render json: current_user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def like
    @user = User.find(params[:id])
    if (interest = current_user.like(@user))
      render json: interest, status: :created
    else
      head :unprocessable_entity
    end
  end

  def unlike
    @user = User.find(params[:id])
    if current_user.unlike(@user)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

    def authorize!
      head :forbidden unless current_user.id == params[:id].to_i
    end

    def user_params
      params.require(:user).permit(:username, :birthdate, :password, :email,
        :country, :gender, :language, :religion)
    end
end
