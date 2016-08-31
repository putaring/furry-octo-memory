class OnboardingController < ApplicationController
  before_action :redirect_if_mobile!
  before_action :authenticate!
  before_action :set_profile, only: [:about, :update_about]

  def about
  end

  def update_about
    if @profile.update_attributes(profile_params)
      redirect_to me_path
    else
      render 'about'
    end
  end

  def photo
    @photo = Photo.new
  end

  def create_photo
    @photo        = current_user.photos.new(photo_params.except(:image))
    @photo.image  = photo_params[:image]

    if @photo.save
      @photo.make_profile_photo
      redirect_to onboarding_photo_path
    else
      render 'photo'
    end
    
  end

  private

  def photo_params
    @_photo_params ||= params.require(:photo).permit(:image, :image_x, :image_y, :image_width)
  end

  def profile_params
    params.require(:profile).permit(:about)
  end

  def set_profile
    @profile = current_user.profile
  end

  def redirect_if_mobile!
    redirect_to me_path if browser.device.mobile?
  end

end
