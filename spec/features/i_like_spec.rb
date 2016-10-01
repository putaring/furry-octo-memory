require 'rails_helper'

feature 'I like' do
  subject { page }
  context "when logged out" do
    background { visit i_like_path }
    it { should have_current_path(login_path) }
  end

  context "when logged in" do
    let(:user)  { create(:user) }
    let(:liked) { create(:user) }
    background do
      visit login_path
      login(user)
      visit i_like_path
    end

    it { should have_content("People I like") }

    context "you don't like anybody" do
      it { should have_content("You haven't liked anybody yet.") }
      it { should have_content("Like people you're interested in to know if they like you.") }
    end

    context "when you like somebody" do
      background do
        interest  = create(:interest, liked: liked, liker: user)
        visit i_like_path
      end

      it { should have_content(liked.username) }
      it { should have_content("Message") }
      it { should have_content("Haven't heard back? Send them a message.") }

      it "should prompt the user page to bring up the message modal" do
        click_link "Message"
        expect(page).to have_current_path(user_path(liked, message_dialog: true))
      end
    end
  end
end
