module AvatarHelper
  def display_picture_for(user)
    asset_url(user.male? ? 'profile_pictures/male.png' : 'profile_pictures/female.png')
  end
end
