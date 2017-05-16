require 'rails_helper'

feature "Admin Panel" do
  context "Admin user" do
    background do
      visit login_path
      login(create(:admin_user))
      visit admin_root_path
    end

    it "should take the user to the admin page" do
      expect(page).to have_current_path(admin_root_path)
    end
  end

  context "Member" do
    background do
      visit login_path
      login(create(:user))
    end

    it "should not allow the user to visit the admin page" do
      expect { visit admin_root_path }.to raise_error(ActionController::RoutingError)
    end
  end
end
