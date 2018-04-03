module AvatarHelper
  def display_picture_for(user)
    avatar = user.avatar
    if avatar.present? && avatar.image_attacher.stored?
      avatar.image_url(:large)
    else
      asset_url(user.male? ? 'profile_pictures/male.png' : 'profile_pictures/female.png')
    end
  end
end
