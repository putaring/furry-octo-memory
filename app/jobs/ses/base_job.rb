module Ses
  class BaseJob < ActiveJob::Base
    include Rails.application.routes.url_helpers

    queue_as 'normal'

    protected

    def self.default_url_options
      Rails.application.config.action_mailer.default_url_options
    end

    def perform(recipient_email)

      self.recipient_email = recipient_email

      ses = Aws::SES::Client.new
      puts ses.send_templated_email(
        source: 'notifications@spouzz.com',
        destination: {
          to_addresses: to_addresses
        },
        template: template,
        template_data: template_data.to_json
      )
    end

    private

    attr_accessor :recipient_email

    def to_addresses
      Array(ENV.fetch('MAIL_INTERCEPT_ADDRESS', recipient_email))
    end

  end
end
