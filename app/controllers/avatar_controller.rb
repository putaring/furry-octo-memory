class AvatarController < ApplicationController
  before_action :authenticate!

  def create
    current_user.create_avatar(avatar_params)
    redirect_to current_user
  end

  private

  def avatar_params
    params.require(:avatar).permit(:image)
  end
end
