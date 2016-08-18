class OnboardingController < ApplicationController
  before_action :authenticate!
  before_action :set_profile, only: [:about, :update_about]

  def about
  end

  def update_about
    if @profile.update_attributes(profile_params)
      redirect_to onboarding_photo_path
    else
      render 'about'
    end
  end

  def photo
  end

  def update_photo
  end

  private

  def profile_params
    params.require(:profile).permit(:about)
  end

  def set_profile
    @profile = current_user.profile
  end

end
