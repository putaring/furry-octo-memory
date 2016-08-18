require 'rails_helper'

feature 'Onboarding' do
  describe "User introduction" do
    context "when user is logged in" do
      let(:user) { create(:user) }
      background do
        visit login_path
        login(user)
        visit onboarding_about_path
      end
      it "should prompt the user to introduce themselves" do
        expect(page).to have_css('form textarea')
      end

      it "should display an error if the user crosses the character limit" do
        fill_in 'profile_about', with: Faker::Lorem.characters(1501)
        click_button 'Done'
        expect(page).to have_content('maximum is 1500 characters')
      end
    end

    context "when user is logged out" do
      it "should redirect the user to the login page" do
        visit onboarding_about_path
        expect(page).to have_current_path(login_path)
      end
    end
  end
end
