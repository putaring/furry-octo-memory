require 'rails_helper'

RSpec.describe Ses::AcceptEmailJob, type: :job do
  include ActiveJob::TestHelper

  let(:job) { described_class.perform_later(interest_id) }

  context 'when the recipient can receive the email' do
    let(:interest_id) { create(:interest, liker: create(:email_preference).user).id }
    it "send an email to the recipient's inbox" do
      expect_any_instance_of(Aws::SES::Client).to receive(:send_templated_email)
      perform_enqueued_jobs { job }
    end
  end

  context 'when the recipient cannot receive the email' do
    let(:interest_id) { create(:interest, liker: create(:disabled_notifications_account).user).id }
    it "doesn't attempt to send the email to the recipient" do
      expect(Rails.logger).to receive(:warn).with(/^Did not send/)
      perform_enqueued_jobs { job }
    end
  end
end
