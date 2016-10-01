require 'rails_helper'

feature 'Likes me' do
  subject { page }
  context "when logged out" do
    background { visit likes_me_path }
    it { should have_current_path(login_path) }
  end

  context "when logged in" do
    let(:user)  { create(:user) }
    let(:liker) { create(:user) }
    background do
      visit login_path
      login(user)
      visit likes_me_path
    end

    it { should have_content("People who like me") }

    context "when nobody likes the user" do
      it { should have_content("0 likes") }
      it { should have_content("Like people you're interested in to know if they like you.") }
    end

    context "when the user has likers" do
      background do
        interest  = create(:interest, liked: user, liker: liker)
        visit likes_me_path
      end

      it { should have_content(liker.username) }
      it { should have_content("Like back") }
      it { should have_content("One of them could be your better half. Connect with them now to find out.") }
    end
  end
end
