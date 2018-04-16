class AvatarController < ApplicationController
  before_action :authenticate!
  before_action :remove_old_avatars, only: :create

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
      head :accepted
    end
  end

  private

  def remove_old_avatars
    Avatar.where(user: current_user).destroy_all
  end

  def avatar_params
    params.require(:avatar).permit(:image)
  end
end
