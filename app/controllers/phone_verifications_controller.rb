class PhoneVerificationsController < ApplicationController
  before_action :authenticate!

  before_action :disallow_unverified_users!, except: [:create, :resend, :verify]

  def create
    phone_verification = current_user.phone_verifications.new(phone_verification_params.merge(ip: request.remote_ip))
    if phone_verification.save
      SendOtpJob.perform_later(phone_verification.id)
      render json: { id: phone_verification.id }, status: :created
    else
      render json: phone_verification.errors.full_messages, status: :unprocessable_entity
    end
  end

  def resend
    phone_verification = current_user.phone_verifications.find(params[:id])
    if phone_verification
      SendOtpJob.perform_later(phone_verification.id)
      head :ok
    else
      head :forbidden
    end
  end

  def verify
    phone_verification = current_user.phone_verifications.find(params[:id])
    if phone_verification.try(:code).eql?(params[:verification_code].strip)
      phone_verification.verify!
      render json: { id: phone_verification.id, user_id: phone_verification.user_id }, status: :ok
    else
      head :forbidden
    end
  end

  private
  def phone_verification_params
    params.require(:phone_verification).permit(:phone_number)
  end

end
