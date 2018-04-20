module Ses
  class DeclineEmailJob < Ses::BaseJob

    def perform(user_id, recipient_id)
      self.recipient  = User.find_by(id: recipient_id)
      self.user       = User.find_by(id: user_id)

      super() if recipient.present? && user.present?
    end

    private

    attr_accessor :user

    def template
      'Decline'
    end

    def template_data
      {
        user:       user.username,
        user_url:   user_url(user),
        search_url: search_url
      }
    end
  end
end
