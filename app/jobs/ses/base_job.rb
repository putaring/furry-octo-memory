module Ses
  class BaseJob < ActiveJob::Base
    queue_as 'normal'

    protected

    def send_email
      ses = Aws::SES.Client.new
      ses.send_templated_email(
        source: 'notifications@spouzz.com',
        destination: {
          to_addresses: to_addresses
        },
        template: template,
        template_data: template_data
      )
    end

    private

    def to_addresses
      Array(ENV.fetch('MAIL_INTERCEPT_ADDRESS', recipient_email))
    end

  end
end
