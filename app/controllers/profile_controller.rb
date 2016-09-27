class ProfileController < ApplicationController
  before_action :authenticate!

  def update
    profile = current_user.profile
    if profile.update_attributes(profile_params)
      head :no_content
    else
      render json: profile.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:about)
  end
end
