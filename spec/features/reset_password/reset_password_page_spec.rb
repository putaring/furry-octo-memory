require 'rails_helper'

feature "Reset Password Page" do
  subject { page }

  background do
    visit reset_password_path(reset_token: reset_token)
  end

  context 'when the token is invalid' do
    let(:reset_token) { SecureRandom.uuid }
    it { should have_text "We couldn't find your account or your link has expired." }
  end

  context 'when the token is valid' do
    let(:verifier) { ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base) }
    let(:expires_at) {  2.hours.from_now }
    let(:user_email) { Faker::Internet.email }
    let(:user_id) { create(:registered_user, email: user_email).id }
    let(:reset_token) { verifier.generate([user_id, expires_at]) }
    context 'but user does not exists' do
      let(:user_id) { 324 }
      it { should have_text "We couldn't find your account or your link has expired." }
    end

    context 'but has expired' do
      let(:expires_at) { 2.hours.ago }
      it { should have_text "We couldn't find your account or your link has expired." }
    end

    context 'user is valid and the token has not expired' do
      it { should have_text "Create a new password for #{user_email}" }

      context 'and the user attempts to reset their password' do
        background do
          fill_in 'user_password',              with: password
          fill_in 'user_password_confirmation', with: password_confirmation
          click_button "Reset your password"
        end

        context 'and password and confirmation do not match' do
          let(:password) { 'qwertyui' }
          let(:password_confirmation) { 'sanjaysanjay' }
          it { should have_text "Password confirmation doesn't match" }
        end

        context 'and password is too small' do
          let(:password) { 'san' }
          let(:password_confirmation) { 'san' }
          it { should have_text "Password is too short (minimum is 6 characters)" }
        end

        context 'and password is successfully reset' do
          let(:password) { 'validpassword' }
          let(:password_confirmation) { 'validpassword' }
          it { should have_text "You're all set That was easy. Log in with your new password to browse matches." }
        end
      end
    end
  end
end
