require 'rails_helper'

feature "Received messages" do
  subject { page }
  let(:user) { create(:user) }
  let(:conversation) { create(:conversation, recipient: user) }
  background do
    visit login_path
    login(user)
  end

  context "has no messages" do
    background { visit messages_path }
    it { should have_content('Inbox') }
    it { should have_content('0 messages') }
    it { should have_content('Take the initiative to contact your matches.') }
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

end
