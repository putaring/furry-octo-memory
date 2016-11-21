require 'rails_helper'

feature "Forgot password" do
  subject { page }


  context "forgot password page" do
    before { visit forgot_password_path }
    it { should have_content("Enter the email address associated with your Roozam.com account. We'll email you a link where you can easily create a new password.") }
  end

end
