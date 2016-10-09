require 'rails_helper'

feature "Sent messages" do
  subject { page }
  let(:user) { create(:user) }
  let(:conversation) { create(:conversation, sender: user) }
  background do
    visit login_path
    login(user)
  end

  context "has not sent any messages" do
    background { visit sent_messages_path }
    it { should have_content('Sent messages') }
    it { should have_content("You've not messaged anybody yet.") }
    it { should have_content('Take the initiative to contact people you like.') }
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

end
