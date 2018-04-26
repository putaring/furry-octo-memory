module AvatarHelper

  def display_picture_for(user, visitor)
    if user.display_photos_to?(visitor)
      avatar_for(user)
    else
      default_avatar_for(user)
    end
  end

  def avatar_for(user)
    avatar = user.avatar
    if avatar.present? && avatar.image_attacher.stored?
      avatar.image_url(:large)
    else
      default_avatar_for(user)
    end
  end

  def default_avatar_for(user)
    asset_url user.male? ? 'profile_pictures/male.jpg' : 'profile_pictures/female.jpg'
  end

end
