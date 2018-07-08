require 'rails_helper'
require 'ses/error_notification_processor'

RSpec.describe Ses::ErrorNotificationProcessor do
  let(:email_preference) { create(:user).email_preference }
  let(:user_email) { email_preference.user.email }
  let(:process_notification) { Ses::ErrorNotificationProcessor.process(notification) }

  context 'when processing bounce notifications' do

    context 'when the bounce is permanent' do
      let(:notification) do
        {
          "notificationType"=>"Bounce", "bounce"=>{"bounceType"=>"Permanent", "bounceSubType"=>"General", "bouncedRecipients"=>[{"emailAddress"=>user_email, "action"=>"failed", "status"=>"5.1.1", "diagnosticCode"=>"smtp; 550 5.1.1 user unknown"}], "timestamp"=>"2018-07-04T21:55:35.250Z", "feedbackId"=>"01020164674b24b3-9b204b3f-044a-4fde-adad-956e427eacb0-000000",
          "remoteMtaIp"=>"207.171.163.188", "reportingMTA"=>"dsn; a4-8.smtp-out.eu-west-1.amazonses.com"}, "mail"=>{"timestamp"=>"2018-07-04T21:55:34.000Z", "source"=>"sanjay.1986@yahoo.com", "sourceArn"=>"arn:aws:ses:eu-west-1:379167613692:identity/sanjay.1986@yahoo.com", "sourceIp"=>"54.240.197.105", "sendingAccountId"=>"379167613692", "messageId"=>"01020164674b221c-f89416d6-bbe9-4bdb-9a99-055b77133dbe-000000",
          "destination"=>["bounce@simulator.amazonses.com"]}
        }
      end
      it 'should mark the email preferece status as permanent bounce' do
        expect { process_notification }.to change { email_preference.reload.status }.from('active').to('permanent_bounce')
      end
    end

    context 'when the bounce is transient' do
      let(:notification) do
        {
          "notificationType"=>"Bounce", "bounce"=>{"bounceType"=>"Transient", "bounceSubType"=>"General", "bouncedRecipients"=>[{"emailAddress"=>user_email}], "timestamp"=>"2018-07-06T23:35:14.000Z", "feedbackId"=>"0102016471f31cba-b7a9b7d9-128c-4884-97fb-b7d6a7c93598-000000"}, "mail"=>{"timestamp"=>"2018-07-06T23:35:15.464Z", "source"=>"sanjay.1986@yahoo.com",
          "sourceArn"=>"arn:aws:ses:eu-west-1:379167613692:identity/sanjay.1986@yahoo.com", "sourceIp"=>"54.240.197.3", "sendingAccountId"=>"379167613692", "messageId"=>"0102016471f3182a-507b16bf-4afe-4fc0-9d1a-0248877b31a9-000000", "destination"=>["ooto@simulator.amazonses.com"]}
        }
      end
      it 'should log notification for manual review' do
        expect(Rails.logger).to receive(:warn).with("Manual Review: #{notification}")
        process_notification
      end
    end

    context 'when the bounce is undetermined' do
      let(:notification) do
        {
          "notificationType"=>"Bounce", "bounce"=>{"bounceType"=>"Undetermined", "bounceSubType"=>"General", "bouncedRecipients"=>[{"emailAddress"=>user_email}], "timestamp"=>"2018-07-06T23:35:14.000Z", "feedbackId"=>"0102016471f31cba-b7a9b7d9-128c-4884-97fb-b7d6a7c93598-000000"}, "mail"=>{"timestamp"=>"2018-07-06T23:35:15.464Z", "source"=>"sanjay.1986@yahoo.com",
          "sourceArn"=>"arn:aws:ses:eu-west-1:379167613692:identity/sanjay.1986@yahoo.com", "sourceIp"=>"54.240.197.3", "sendingAccountId"=>"379167613692", "messageId"=>"0102016471f3182a-507b16bf-4afe-4fc0-9d1a-0248877b31a9-000000", "destination"=>["ooto@simulator.amazonses.com"]}
        }
      end

      it 'should log notification for manual review' do
        expect(Rails.logger).to receive(:warn).with("Manual Review: #{notification}")
        process_notification
      end
    end
  end

  context 'when processing complaint notifications' do
    let(:notification) do
      {
        "notificationType"=>"Complaint", "complaint"=>{"complainedRecipients"=>[{"emailAddress"=>user_email}], "timestamp"=>"2018-07-06T23:35:29.000Z", "feedbackId"=>"0102016471f356a9-b8b669e2-0dd0-4735-b3b8-6f1592e37dca-000000", "userAgent"=>"Amazon SES Mailbox Simulator",
        "complaintFeedbackType"=>"abuse"}, "mail"=>{"timestamp"=>"2018-07-06T23:35:30.235Z", "source"=>"sanjay.1986@yahoo.com", "sourceArn"=>"arn:aws:ses:eu-west-1:379167613692:identity/sanjay.1986@yahoo.com", "sourceIp"=>"54.240.197.3", "sendingAccountId"=>"379167613692", "messageId"=>"0102016471f35089-2a9fb1aa-4a6a-46b3-a20d-b25a19dc3baa-000000", "destination"=>["complaint@simulator.amazonses.com"]}
      }
    end

    it 'should disable receiving email notifications on the account' do
      expect { process_notification }.to change { email_preference.reload.receive_notifications }.from(true).to(false)
    end
  end
end
