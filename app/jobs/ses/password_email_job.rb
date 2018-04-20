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
      { password_reset_url: reset_password_url(reset_token: recipient.reset_token) }
    end
  end
end
