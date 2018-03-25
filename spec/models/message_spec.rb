require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:sender) }
  it { should belong_to(:recipient) }
  it { should belong_to(:conversation) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(1000) }

  describe ".unread" do
    before { create(:message, sender: sender, read: false) }
    context "when messages are from active users" do
      let(:sender) { create(:sender) }
      it "should return unread messages" do
        expect(Message.unread.count).to be_present
      end
    end

    context "when messages are from inactive users" do
      let(:sender) { create(:inactive_user) }
      it "should not return messages from inactive users" do
        expect(Message.unread).to be_empty
      end
    end

  end

end
