class PreferenceController < ApplicationController
  before_action :authenticate!

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(preference_params)
      redirect_to edit_preference_path, notice: 'Updated.'
    else
      render 'edit'
    end
  end

  private

  def preference_params
    params.require(:profile).permit(:preference)
  end
end
