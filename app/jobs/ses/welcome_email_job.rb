module Ses
  class WelcomeEmailJob < Ses::BaseJob
    def perform(user_id)
      super(User.find(user_id).email)
    end

    private

    def template
      'Welcome'
    end

    def template_data
      { login_url: login_url }
    end
  end
end
