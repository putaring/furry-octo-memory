require 'rails_helper'

feature "Reset password" do
  subject { page }

  describe "valid reset page" do
    let(:user) { create(:user) }
    background { visit reset_password_path(user.reset_token) }

    it { should have_content("Create a new password for #{user.email}") }

    context "valid password" do
      background do
        fill_in 'user_password',              with: 'qwerty'
        fill_in 'user_password_confirmation', with: 'qwerty'
        click_button 'Reset your password'
      end
      it { should have_content('Log in with your new password to browse matches') }
    end

    context "wrong password confirmation" do
      background do
        fill_in 'user_password',              with: 'qwerty'
        fill_in 'user_password_confirmation', with: 'qwerty1'
        click_button 'Reset your password'
      end
      it { should have_content("Password confirmation doesn't match") }
    end

    context "short password" do
      background do
        fill_in 'user_password',              with: 'qwy'
        fill_in 'user_password_confirmation', with: 'qwy'
        click_button 'Reset your password'
      end
      it { should have_content("Password is too short (minimum is 6 characters)") }
    end
  end

  describe "invalid reset page" do
    background { visit reset_password_path("loremipsum") }
    it { should have_content("We couldn't find your account") }
  end
end
