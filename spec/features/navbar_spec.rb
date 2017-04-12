require 'rails_helper'
feature "Navbar" do
  let(:user) { create(:user) }
  context "when logged in" do

    background do
      visit login_path
      login(user)
      visit user_path(user)
    end
    it "should give the user the option of logging out" do
      within('.navbar') { expect(page).to have_content('Log out') }
    end
  end

  context "when logged out" do
    it "should give the user the option of logging in" do
      visit user_path(user)
      within('.navbar') { expect(page).to have_content('Log in') }
    end
  end
end
