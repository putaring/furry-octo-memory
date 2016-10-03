require 'rails_helper'

feature "Conversation Page" do
  subject { page }
  let(:recipient)   { create(:recipient) }
  let(:sender)      { create(:sender) }
  let(:conversation) { create(:conversation, sender: sender, recipient: recipient) }

  background do
    create(:message, sender: sender, recipient: recipient, conversation: conversation, body: "First message")
    create(:message, sender: sender, recipient: recipient, conversation: conversation, body: "Second message")
    create(:message, sender: sender, recipient: recipient, conversation: conversation, body: "Last message")
    create(:message, sender: recipient, recipient: sender, conversation: conversation, body: "First message")
    create(:message, sender: recipient, recipient: sender, conversation: conversation, body: "Second message")
    create(:message, sender: recipient, recipient: sender, conversation: conversation, body: "Last message")
    visit login_path
    login(recipient)
    visit conversation_path(conversation)
  end

  it { should have_content('Show older messages') }
  it { should have_content('Last message') }

  it "should mark all received messages of the logged in user as read" do
    expect(conversation.messages.where(recipient_id: recipient.id, read: false).count).to eq(0)
  end

  it "should not mark received messages of the sender as read" do
    expect(conversation.messages.where(recipient_id: sender.id, read: false).count).to eq(3)
  end
end
