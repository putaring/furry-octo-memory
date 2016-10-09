require 'rails_helper'

feature 'Mutual likes' do
  subject { page }
  context "when logged out" do
    background { visit mutual_likes_path }
    it { should have_current_path(login_path) }
  end

  context "when logged in" do
    let(:user)  { create(:user) }
    let(:liker) { create(:user) }
    background do
      visit login_path
      login(user)
      visit mutual_likes_path
    end

    it { should have_content("You like each other") }

    context "when nobody likes the user" do
      it { should have_content("No mutual likes.") }
      it { should have_content("Keep searching.") }
    end

    context "has no mutual likes" do
      background do
        create(:interest, liked: user, liker: liker)
        create(:interest, liked: create(:user), liker: user)
        visit mutual_likes_path
      end
      it { should have_content("No mutual likes.") }
      it { should have_content("Keep searching.") }
    end

    context "when the user has mutual likes" do
      background do
        create(:interest, liked: user, liker: liker)
        create(:interest, liked: liker, liker: user)
        visit mutual_likes_path
      end

      it { should have_content(liker.username) }
    end
  end
end
