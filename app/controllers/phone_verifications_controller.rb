class PhoneVerificationsController < ApplicationController
  before_action :authenticate!

  def create
    phone_verification = current_user.phone_verifications.new(phone_verification_params.merge(ip: request.remote_ip))
    if phone_verification.save
      render json: {id: phone_verification.id}, status: :created
    else
      render json: phone_verification.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  def phone_verification_params
    params.require(:phone_verification).permit(:phone_number)
  end

end
