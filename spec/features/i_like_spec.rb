require 'rails_helper'

feature 'I like' do
  subject { page }
  context "when logged out" do
    background { visit i_like_path }
    it { should have_current_path(login_path) }
  end

  context "when logged in" do
    let(:user)          { create(:user) }
    let(:liked)         { create(:user) }
    let(:inactive_user) { create(:inactive_user)}
    background do
      visit login_path
      login(user)
      visit i_like_path
    end

    it { should have_content("People I like") }

    context "you don't like anybody" do
      it { should have_content("You haven't liked anybody yet.") }
    end

    context "when you like somebody" do
      background do
        create(:interest, liked: liked, liker: user)
        create(:interest, liked: inactive_user, liker: user)
        visit i_like_path
      end

      it { should have_content(liked.username) }
      it { should_not have_content(inactive_user.username) }

    end
  end
end
