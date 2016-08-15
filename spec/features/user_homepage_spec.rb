require "rails_helper"

feature 'User homepage' do
  context "when logged out" do
    scenario "should redirect user to the login page" do
      visit me_path
      expect(page).to have_current_path(login_path)
    end
  end
end
