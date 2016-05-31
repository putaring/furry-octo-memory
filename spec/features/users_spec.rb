require 'rails_helper'

feature "Users" do

  subject { page }

  describe "Sign up page" do
    background { visit signup_path }
    it { should have_title('Signup') }
    it { should have_content('Get started') }
  end
end
