module Ses
  class BounceNotificationProcessor < Ses::ErrorNotificationProcessor
    def self.process(notification)
      new notification
    end

    private

    def process
      case bounce_type
      when 'Permanent'
        User.where(email: bounced_emails).each do |user|
          user.email_preference.permanent_bounce!
        end
      else
        Rails.logger.warn "Manual Review: #{notification}"
      end
    end

    def bounce_type
      @_bounce_type ||= notification['bounce']['bounceType']
    end

    def bounce_sub_type
      @_bounce_sub_type ||= notification['bounce']['bounceSubType']
    end

    def bounced_emails
      @_bounced_emails ||= notification['bounce']['bouncedRecipients'].map { |r| r['emailAddress'].strip }
    end

  end
end
