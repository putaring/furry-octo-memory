require 'rails_helper'

feature "Authentication" do
  describe "Logging in" do
    background { visit login_path }

    context "with invalid credentials" do
      background do
        fill_in 'session_email',    with: Faker::Internet.email
        fill_in 'session_password', with: Faker::Internet.password
        click_button "Login"
      end
      scenario "should not log the user in" do
        expect(page).to have_current_path(login_path)
      end

      scenario "should display an error message" do
        expect(page).to have_content('Invalid email/password combination. Please try again.')
      end
    end

    context "with valid credentials" do
      given(:user) { create(:user) }
      background { login(user) }

      scenario "should redirect user to the user's homepage" do
        expect(page).to have_current_path(me_path)
      end
    end
  end

  describe "Login page" do
    context "when logged in" do
      it "should redirect user to the user landing page" do
        visit login_path
        login(create(:user))
        visit login_path
        expect(page).to have_current_path(me_path)
      end
    end
  end
end
