module Ses
  class ComplaintNotificationProcessor < Ses::ErrorNotificationProcessor
    def self.process(notification)
      new notification
    end

    private

    def process
      User.where(email: complaint_emails).each do |user|
        user.email_preference.update(receive_notifications: false)
      end
    end

    def complaint_emails
      @_complaint_emails ||= notification['complaint']['complainedRecipients'].map { |r| r['emailAddress'].strip }
    end

  end
end
