require 'rails_helper'

feature "Forgot password" do
  subject { page }

  context "forgot password page" do
    before { visit forgot_password_path }
    it { should have_content("Enter the email address associated with your Spouzz.com account. We'll email you a link where you can easily create a new password.") }
  end

  describe "request password reset" do
    given(:email) { Faker::Internet.email }
    before do
      visit forgot_password_path
      fill_in 'email', with: email
      click_button 'Continue ➞'
    end

    scenario "should show reset intructions to user" do
      expect(page).to have_current_path(check_your_email_path(email: email.downcase.strip))
    end
  end
end
