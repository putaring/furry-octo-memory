class SendOtpJob < ActiveJob::Base
  queue_as :urgent

  def perform(phone_verification_id)
    PhoneVerification.find(phone_verification_id).send_code
  end
end
