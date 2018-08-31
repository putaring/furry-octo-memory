class AvatarController < ApplicationController
  before_action :authenticate!

  def create
    current_user.create_avatar(avatar_params)
    redirect_to current_user
  end

  def show
    if current_user.avatar.image_attacher.stored?
      render json: {
        url: current_user.avatar.image_url(:large)
      }
    else
      render json: {}, status: :accepted
    end
  end

  private

  def avatar_params
    params.require(:avatar).permit(:image)
  end
end
