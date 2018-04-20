module Ses
  class AcceptEmailJob < Ses::BaseJob

    def perform(interest_id)
      interest = Interest.find_by(id: interest_id)
      if interest.present?
        self.recipient  = interest.liked
        self.liker      = interest.liker
        super()
      end
    end

    private

    attr_accessor :liker

    def template
      'Accept'
    end

    def template_data
      {
        liker:              liker.username,
        liker_avatar_url:   ApplicationController.helpers.liker_avatar_url(liker),
        liker_url:          user_url(liker)
      }
    end
  end
end
