require 'rails_helper'

feature "Sent messages" do
  subject { page }
  let(:user)                    { create(:user) }
  let(:inactive_user)           { create(:inactive_user) }
  let(:conversation)            { create(:conversation, sender: user) }
  let(:inactive_conversation)   { create(:conversation, sender: user, recipient: inactive_user) }

  background do
    visit login_path
    login(user)
  end

  context "has not sent any messages" do
    background { visit sent_messages_path }
    it { should have_content('Sent messages') }
    it { should have_content("You've not messaged anybody yet.") }
  end

  context "has unread sent messages" do
    background do
      create(:message, sender: user, conversation: conversation, body: "First message")
      create(:message, sender: user, conversation: conversation, body: "Second message")
      create(:message, sender: user, conversation: conversation, body: "Last message")
      visit sent_messages_path
    end

    it { should have_content('Last message') }
    it { should have_content('unread') }
  end

  context "has message from inactive user" do
    background do
      create(:message, sender: user, recipient: inactive_user, conversation: inactive_conversation, body: "First message")
      visit messages_path
    end
    it { should have_content('0 messages') }
  end
end
