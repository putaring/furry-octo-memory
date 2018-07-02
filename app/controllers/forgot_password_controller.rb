class ForgotPasswordController < ApplicationController

  def send_instructions
    user  = User.find_by(email: params[:email].downcase.strip)
    Ses::PasswordEmailJob.perform_later(user.id) if user.present?

    redirect_to check_your_email_path
  end

  def reset_password
    user_id, expires_at = verifier.verify params[:reset_token]
    @user = User.find_by(id: user_id) if Time.zone.now < expires_at
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
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

  def verifier
    ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
