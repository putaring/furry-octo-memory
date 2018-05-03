require 'rails_helper'

feature "Authentication" do
  subject { page }

  context 'when user attempts to login' do
    background do
      visit login_path
      fill_in 'session_email',    with: email
      fill_in 'session_password', with: password
      click_button "Login"
    end
    context 'with invalid credentials' do
      let(:email) { Faker::Internet.email }
      let(:password) { Faker::Internet.password }
      it { should have_current_path(login_path) }
      it { should have_text 'Invalid email or password.' }
    end

    context 'with valid credentials' do
      let(:email) { user.email }
      let(:password) { 'password' }
      context 'and is an admin' do
        let(:user) { create(:admin_user, password: 'password') }
        it { should have_current_path(admin_root_path) }
      end

      context 'and is a member' do
        let(:user) { create(:user, password: 'password') }
        it { should have_current_path(user_path(user)) }
      end
    end
  end

  context 'when attempting to access a protected page' do
    background do
      visit photos_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: 'password'
      click_button "Login"
    end
    let(:user) { create(:user, password: 'password') }
    it { should have_current_path photos_path }
  end
end
