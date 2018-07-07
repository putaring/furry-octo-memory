require 'rails_helper'

RSpec.describe EmailPreference, type: :model do
  context 'validations' do
    subject { build(:email_preference) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_uniqueness_of(:user) }
  end

  describe '#receive_email_notifications?' do
    context 'when the user has turned on notifications' do
      context 'but mailbox is bouncing emails' do
        specify { expect(create(:permanent_bounce_account).receive_email_notifications?).to be false }
      end
      context 'and mailbox is active' do
        specify { expect(create(:active_email_account).receive_email_notifications?).to be true }
      end
    end

    context 'when the user has turned off notifications' do
      context 'but mailbox is bouncing emails' do
        specify { expect(create(:disabled_notifications_account, status: :permanent_bounce).receive_email_notifications?).to be false }
      end
      context 'and mailbox is active' do
        specify { expect(create(:disabled_notifications_account, status: :active).receive_email_notifications?).to be false }
      end
    end
  end
end
