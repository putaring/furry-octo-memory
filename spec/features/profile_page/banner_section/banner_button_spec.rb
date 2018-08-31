require 'rails_helper'

feature 'Banner buttons' do
  given(:user) { create(:registered_user) }
  subject(:buttons_section) { page.find('.jumbotron') }

  context "Viewing the user's profile page" do
    context 'as an anonymous user' do
      background { visit user_path(user) }
      it { should have_link('Login', href: login_path) }
      it { should have_link('Sign up', href: signup_path) }
    end

    context 'as a logged in user' do
      background do
        login_as visitor
        visit user_path(user)
      end

      context 'and is a visitor' do
        context 'who has liked the user' do
          let(:visitor) { create(:interest, liked: user).liker }
          it { should have_link('Unlike') }
          it { should have_link('Message') }
        end

        context 'who has not liked the user' do
          let(:visitor) { create(:registered_user) }
          it { should have_link('Like') }
          it { should have_link('Message') }
        end

      end

      context 'and is self' do
        let(:visitor) { user }
        it { should have_link('Edit', href: edit_details_path) }
      end
    end
  end

end
