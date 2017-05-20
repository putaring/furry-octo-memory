class Admin::UsersController < Admin::AdminController

  def show
    @user = User.includes(:photos, :profile).find(params[:id])
  end

  def ban
    user = User.find(params[:user_id])
    user.banned!

    redirect_to admin_user_path(user), notice: "Account is banned."
  end

  def activate
    user = User.find(params[:user_id])
    user.active!

    redirect_to admin_user_path(user), notice: "Account is active."
  end
end
