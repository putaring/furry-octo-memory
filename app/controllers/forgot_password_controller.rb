class ForgotPasswordController < ApplicationController

  def send_instructions
    email = params[:email].downcase.strip
    user  = User.find_by(email: email)
    UserMailer.password_email(user).deliver_now if user.present?

    redirect_to check_your_email_path(email: email)
  end

  def check_email
    redirect_to forgot_password_path if params[:email].blank?
  end

  def reset_password
    @user = User.find_by(reset_token: params[:reset_token])
  end

  def change_password
    @user = User.find_by(reset_token: params[:reset_token])
    if @user && @user.update_attributes(password_params)
      @user.regenerate_reset_token
      render 'changed_password'
    else
      render 'reset_password'
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
