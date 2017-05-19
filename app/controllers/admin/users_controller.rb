class Admin::UsersController < Admin::AdminController

  def show
    @user = User.includes(:photos, :profile).find(params[:id])
  end

end
