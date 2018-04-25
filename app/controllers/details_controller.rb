class DetailsController < ApplicationController
  before_action :authenticate!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(details_params)
      redirect_to edit_details_path, notice: 'Updated.'
    else
      render 'edit'
    end
  end

  private

  def details_params
    params.require(:user).permit(:username, :birthdate, :email,:country, :gender, :language, :religion, :height, :status, :sect)
  end
end
