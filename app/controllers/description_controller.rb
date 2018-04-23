class DescriptionController < ApplicationController
  before_action :authenticate!

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(description_params)
      redirect_to edit_description_path, notice: 'Updated.'
    else
      render 'edit'
    end
  end

  private

  def description_params
    params.require(:profile).permit(:about)
  end

end
