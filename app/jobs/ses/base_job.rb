module Ses
  class BaseJob < ActiveJob::Base
    include Rails.application.routes.url_helpers

    queue_as 'normal'

    protected

    attr_accessor :recipient

    def perform
      ses = Aws::SES::Client.new
      ses.send_templated_email(
        source: ENV.fetch('TRANSACTIONAL_FROM_EMAIL'),
        destination: {
          to_addresses: to_addresses
        },
        template: template,
        template_data: template_data.to_json
      )
    end

    def self.default_url_options
      Rails.application.config.action_mailer.default_url_options
    end

    private

    def to_addresses
      Array(ENV.fetch('MAIL_INTERCEPT_ADDRESS', recipient.email))
    end

  end
end
