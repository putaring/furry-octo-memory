class WorkController < ApplicationController
  before_action :authenticate!

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(work_params)
      redirect_to edit_work_path, notice: 'Updated.'
    else
      render 'edit'
    end
  end

  private

  def work_params
    params.require(:profile).permit(:occupation)
  end
end
