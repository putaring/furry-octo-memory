require 'rails_helper'

RSpec.describe EmailPreference, type: :model do
  context 'validations' do
    subject { build(:email_preference) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_uniqueness_of(:user) }
  end

  describe '#receive_email_notifications?' do
    let(:email_preference) { create(:user).email_preference }
    before { email_preference.update(email_preference_attributes) }
    context 'when the user has turned on notifications' do
      context 'but mailbox is bouncing emails' do
        let(:email_preference_attributes) { { status: :permanent_bounce} }
        specify { expect(email_preference.receive_email_notifications?).to be false }
      end
      context 'and mailbox is active' do
        let(:email_preference_attributes) { { status: :active } }
        specify { expect(email_preference.receive_email_notifications?).to be true }
      end
    end

    context 'when the user has turned off notifications' do
      context 'but mailbox is bouncing emails' do
        let(:email_preference_attributes) { { receive_notifications: false, status: :permanent_bounce} }
        specify { expect(email_preference.receive_email_notifications?).to be false }
      end
      context 'and mailbox is active' do
        let(:email_preference_attributes) { { receive_notifications: false, status: :active} }
        specify { expect(email_preference.receive_email_notifications?).to be false }
      end
    end
  end
end
