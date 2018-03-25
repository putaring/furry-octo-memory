require 'rails_helper'

RSpec.describe Conversation, type: :model do
  subject(:conversation)  { create(:conversation, sender: sender, recipient: recipient) }
  let(:sender)            { create(:sender) }
  let(:recipient)         { create(:recipient) }

  context 'validations' do
    it { should belong_to(:sender) }
    it { should belong_to(:recipient) }
    it { should have_many(:messages) }
    it { should validate_presence_of(:sender) }
    it { should validate_presence_of(:recipient) }
    it { should validate_uniqueness_of(:sender_id).scoped_to(:recipient_id) }
  end

  describe "#other_participant" do
    it { expect(conversation.other_participant(sender)).to eq(recipient) }
    it { expect(conversation.other_participant(recipient)).to eq(sender) }
  end

  describe ".between" do
    before  { create(:conversation, sender: sender, recipient: recipient) }
    context "sender and recipient ids are inputted in that order" do
      it { expect(Conversation.between(sender.id, recipient.id)).to be_present }
    end
    context "when recipient and sender ids are inputted in that order" do
      it { expect(Conversation.between(recipient.id, sender.id)).to be_present }
    end
    context "when querying conversation between users who have never messages each other" do
      it { expect(Conversation.between(sender.id, create(:user).id)).to be_nil }
    end
  end

  describe ".with_participant" do
    context "when the user has engaged in conversations" do
      before  { create(:conversation, sender: sender) }
      it "should return all the conversation with the participant" do
        expect(Conversation.with_participant(sender)).to be_present
      end
    end

    context "when the user has never had a conversation" do
      it { expect(Conversation.with_participant(create(:user))).to be_empty }
    end
  end
end
