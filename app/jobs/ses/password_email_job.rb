module Ses
  class PasswordEmailJob < Ses::BaseJob
    def perform(user_id)
      self.recipient = User.find_by(id: user_id)
      super() if recipient.present?
    end

    private

    def template
      'Password'
    end

    def template_data
      { password_reset_url: reset_password_url(reset_token: reset_token) }
    end

    def reset_token
      verifier = ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
      verifier.generate([recipient.id, 2.hours.from_now])
    end
  end
end
