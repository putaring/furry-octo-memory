class SendOtpJob < ActiveJob::Base
  queue_as 'critical'

  def perform(phone_verification_id)
    phone_verification = PhoneVerification.find(phone_verification_id)
    sns_client = Aws::SNS::Client.new
    publish_response = sns_client.publish({
      phone_number: phone_verification.phone_number,
      message: "Your Spouzz verification code is #{phone_verification.code}",
      message_attributes: {
        'AWS.SNS.SMS.SMSType' => {
          data_type: "String",
          string_value: "Transactional"
        }
      }
    })
    phone_verification.update_attributes(session_id: publish_response.message_id)
  end
end
