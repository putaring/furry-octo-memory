require 'rails_helper'

RSpec.describe Conversation, type: :model do

  context 'validations' do
    subject { create(:conversation) }
    it { should belong_to(:sender) }
    it { should belong_to(:recipient) }
    it { should validate_presence_of(:sender) }
    it { should validate_presence_of(:recipient) }
    it { should validate_uniqueness_of(:sender_id).scoped_to(:recipient_id) }
  end

  let(:sender)        { create(:sender) }
  let(:recipient)     { create(:recipient) }
  let(:user)          { create(:user) }

  describe ".between" do
    it "should return the conversation between sender and recipient" do
      conversation = create(:conversation, sender: sender, recipient: recipient)
      expect(Conversation.between(sender.id, recipient.id)).to eq(conversation)
      expect(Conversation.between(recipient.id, sender.id)).to eq(conversation)
    end

    it "should return nil if the users have never communicated" do
      expect(Conversation.between(sender.id, user.id)).to eq(nil)
    end
  end

  describe ".with_participant" do
    it "should return all the conversation with the participant" do
      conversation1 = create(:conversation, sender: sender, recipient: recipient)
      conversation2 = create(:conversation, sender: sender, recipient: user)
      expect(Conversation.with_participant(sender)).to include(conversation1, conversation2)
    end

    it "should return an empty array if the user has never had a conversation" do
      expect(Conversation.with_participant(sender)).to be_empty
    end
  end

end
