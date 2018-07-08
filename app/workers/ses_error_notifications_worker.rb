require 'ses/error_notification_processor'
class SesErrorNotificationsWorker
  include Shoryuken::Worker
  shoryuken_options queue: -> { "#{[ActiveJob::Base.queue_name_prefix, ActiveJob::Base.queue_name_delimiter].join}ses_error_notifications" },
                    body_parser: :json,
                    auto_delete: false

  def perform(_, notification)
    Ses::ErrorNotificationProcessor.process(JSON.parse notification['Message'])
  end
end
