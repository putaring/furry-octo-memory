require 'rails_helper'

feature "Received messages" do
  subject { page }
  let(:user)                    { create(:member) }
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
    it { should have_content('Start a conversation') }
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
    it { should have_css('.badge.badge-pill.badge-danger') }
    it "should display unread notification count" do
      expect(page.find('.badge.badge-pill.badge-danger')).to have_content(3)
    end
  end

  context "has message from inactive user" do
    background do
      create(:message, recipient: user, sender: inactive_user, conversation: inactive_conversation, body: "First message")
      visit messages_path
    end
    it { should have_content('Start a conversation') }
    it { should_not have_css('.badge.badge-pill.badge-danger') }
  end
end
