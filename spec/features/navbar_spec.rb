require 'rails_helper'
feature "Navbar" do
  let(:user) { create(:user) }
  context "when logged in" do

    background do
      visit login_path
      login(user)
      visit user_path(user)
    end
    it "should give the user the option of logging in or signing up" do
      within('.navbar-full') { expect(page).to have_content('Log in / Sign up') }
    end
  end

  context "when logged out" do

  end
end
