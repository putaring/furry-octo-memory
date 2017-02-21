require 'rails_helper'

feature 'Likes me' do
  subject { page }
  context "when logged out" do
    background { visit likes_me_path }
    it { should have_current_path(login_path) }
  end

  context "when logged in" do
    let(:user)          { create(:user) }
    let(:liker)         { create(:user) }
    let(:inactive_user) { create(:inactive_user)}
    background do
      visit login_path
      login(user)
      visit likes_me_path
    end

    it { should have_content("People who like me") }

    context "when nobody likes the user" do
      it { should have_content("0 likes") }
    end

    context "when the user has likers" do
      background do
        create(:interest, liked: user, liker: liker)
        create(:interest, liked: user, liker: inactive_user)
        visit likes_me_path
      end

      it { should have_content(liker.username) }
      it { should_not have_content(inactive_user.username) }
    end
  end
end
