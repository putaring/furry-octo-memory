class UsersController < ApplicationController

  before_action :redirect_if_logged_in!, only: [:new, :create]
  before_action :authenticate!, only: [:like, :unlike]

  def show
    @user     = User.active.find(params[:id])
    @photos   = @user.photos.reverse_order.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(ip: request.remote_ip))
    if @user.save
      login(@user)
      Ses::WelcomeEmailJob.perform_later(@user.id)
      redirect_to verify_path
    else
      render 'new'
    end
  end

  def like
    @user = User.find(params[:id])
    if (interest = current_user.like(@user))
      #@user.likes?(current_user) ? UserMailer.match_email(interest.id).deliver_later : UserMailer.like_email(interest.id).deliver_later
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

  def favorite
    @user = User.find(params[:id])
    if (bookmark = current_user.favorite(@user))
      render json: bookmark, status: :created
    else
      head :unprocessable_entity
    end
  end

  def unfavorite
    @user = User.find(params[:id])
    if current_user.unfavorite(@user)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def decline
    @user = User.find(params[:id])
    if current_user.decline(@user)
      UserMailer.decline_email(@user.id, current_user.id).deliver_later
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
