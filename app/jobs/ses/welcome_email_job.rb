module Ses
  class WelcomeEmailJob < Ses::BaseJob
    def perform(user_id)
      self.recipient = User.find_by(id: user_id)
      super() if recipient.present?
    end

    private

    def send_email?
      true
    end

    def template
      'Welcome'
    end

    def template_data
      { login_url: login_url }
    end
  end
end
