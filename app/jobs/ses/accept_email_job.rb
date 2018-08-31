module Ses
  class AcceptEmailJob < Ses::BaseJob

    def perform(interest_id)
      interest = Interest.find_by(id: interest_id)
      if interest.present?
        self.recipient  = interest.liker
        self.liked      = interest.liked
        super()
      end
    end

    private

    attr_accessor :liked

    def send_email?
      recipient.email_preference.receive_email_notifications?
    end

    def template
      'Accept'
    end

    def template_data
      {
        liker:              liked.username,
        liker_avatar_url:   ApplicationController.helpers.avatar_for(liked),
        liker_url:          user_url(liked)
      }
    end
  end
end
