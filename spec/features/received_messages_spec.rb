require 'rails_helper'

feature "Received messages" do
  subject { page }
  let(:user)                    { create(:user) }
  let(:inactive_user)           { create(:inactive_user) }
  let(:conversation)            { create(:conversation, recipient: user) }
  let(:inactive_conversation)   { create(:conversation, recipient: user, sender: inactive_user) }
  background do
    visit login_path
    login(user)
  end

  context "has no messages" do
    background { visit messages_path }
    it { should have_content('Inbox') }
    it { should have_content('0 messages') }
  end

  context "has unread messages" do
    background do
      create(:message, recipient: user, conversation: conversation, body: "First message")
      create(:message, recipient: user, conversation: conversation, body: "Second message")
      create(:message, recipient: user, conversation: conversation, body: "Last message")
      visit messages_path
    end

    it { should have_content('Last message') }
    it { should have_content('unread') }
  end

  context "has message from inactive user" do
    background do
      create(:message, recipient: user, sender: inactive_user, conversation: inactive_conversation, body: "First message")
      visit messages_path
    end
    it { should have_content('0 messages') }
  end
end
