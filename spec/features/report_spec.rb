require 'rails_helper'

feature "Report a user" do
  describe "Reporting a user from the profile page" do
    context "Logged out" do
      it "should not give the user an option report the profile" do
        visit user_path(create(:user))
        expect(page).to_not have_content('Report user')
      end
    end

    context "Logged in" do
      background do
        visit login_path
        login(create(:user))
      end

      it "should give the user an option to report the profile" do
        visit user_path(create(:user))
        within('.jumbotron') { expect(page).to have_content('Report user') }
        within('#report-modal') { expect(page).to have_content('Report user') }
      end
    end
  end
end
