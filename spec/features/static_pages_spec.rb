require 'rails_helper'

feature 'Static pages' do
  describe "Home page" do
    context "when logged out" do
      it "should keep display the home page" do
        visit root_path
        expect(page).to have_current_path(root_path)
      end
    end

    context "when logged_in" do
      background do
        visit login_path
        login(create(:user))
      end
      it "should redirect to user home page" do
        visit root_path
        expect(page).to have_current_path(me_path)
      end
    end
  end
end
