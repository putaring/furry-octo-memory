module Ses
  class ErrorNotificationProcessor

    def self.process(notification)
      notification_type = notification['notificationType']
      require_relative "#{notification_type.downcase}_notification_processor.rb"
      Ses.const_get("#{notification_type.classify}NotificationProcessor").process(notification)
    end

    protected

    attr_accessor :notification

    def initialize(notification)
      self.notification = notification
      process
    end
  end
end
