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
        expect(page).to have_content('Invalid email or password.')
      end
    end

    context "with valid credentials" do
      context "active user" do
        given(:member) { create(:member) }
        background { login(member) }

        scenario "should redirect user to the user's homepage" do
          expect(page).to have_current_path(user_path(member))
        end
      end

      context "admin user" do
        background { login(create(:admin_user)) }

        scenario "should redirect user to the admin root" do
          expect(page).to have_current_path(admin_root_path)
        end
      end
    end
  end

  describe "Login page" do
    context "when logged in as active user" do
      given(:member) { create(:member) }
      it "should redirect user to the user landing page" do
        visit login_path
        login(member)
        visit login_path
        expect(page).to have_current_path(user_path(member))
      end
    end

    context "when logged in as admin user" do
      it "should redirect admin user to the admin root page" do
        visit login_path
        login(create(:admin_user))
        visit login_path
        expect(page).to have_current_path(admin_root_path)
      end
    end
  end
end
