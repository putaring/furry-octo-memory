class UsersController < ApplicationController

  before_action :redirect_if_logged_in!, only: [:new, :create]
  before_action :authenticate!, only: [:like, :unlike]

  def show
    @user = User.active.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      UserMailer.welcome_email(@user).deliver_now
      redirect_to me_path
    else
      render 'new'
    end
  end

  def like
    @user = User.find(params[:id])
    if (interest = current_user.like(@user))
      @user.likes?(current_user) ? UserMailer.match_email(interest).deliver_now : UserMailer.like_email(interest).deliver_now
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

    def user_params
      params.require(:user).permit(:username, :birthdate, :password, :email,
        :country, :gender, :language, :religion, :height, :status, :sect)
    end
end
