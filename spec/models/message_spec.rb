require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:sender) }
  it { should belong_to(:recipient) }
  it { should belong_to(:conversation) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(1000) }

  describe ".unread" do
    it "should return unread messages" do
      3.times { create(:message, read: false) }
      2.times { create(:message, read: true) }

      expect(Message.unread.count).to eq(3)
    end

    it "should not return messages from inactive users" do
      create(:message, sender: create(:inactive_user), body: "First message", read: false)
      expect(Message.unread.count).to eq(0)
    end
  end

end
