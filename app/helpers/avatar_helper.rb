module AvatarHelper

  def display_picture_for(user)
    default_avatar = asset_url(user.male? ? 'profile_pictures/male.png' : 'profile_pictures/female.png')
    if user.display_photos_to?(current_user)
      avatar = user.avatar
      if avatar.present? && avatar.image_attacher.stored?
        avatar.image_url(:large)
      else
        default_avatar
      end
    else
      default_avatar
    end
  end

  def liker_avatar_url(liker)
    default_avatar  = asset_url(liker.male? ? 'profile_pictures/male.png' : 'profile_pictures/female.png')
    avatar          = liker.avatar
    if avatar.present? && avatar.image_attacher.stored?
      avatar.image_url(:large)
    else
      default_avatar
    end
  end

end
