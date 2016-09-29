require 'rails_helper'

feature 'Likes me' do
  subject { page }
  context "when logged out" do
    background { visit likes_me_path }
    it { should have_current_path(login_path) }
  end

  context "when logged in" do
    background do
      visit login_path
      login(create(:user))
      visit likes_me_path
    end

    it { should have_content("People who like me") }
    context "when nobody likes the user" do
      it { should have_content("0 likes") }
      it { should have_content("Like other people to know if they like you back.") }
    end

    context "when the user has likers" do
      it "should display users who have liked the user" do

      end
      it "should give the user the option to like users who have liked them" do

      end
    end
  end
end
