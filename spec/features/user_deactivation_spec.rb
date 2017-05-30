require 'rails_helper'

feature 'User deactivation' do

  context "inactive user" do
    subject { page }
    let(:inactive_user) { create(:inactive_user) }
    background do
      visit login_path
      login(inactive_user)
    end

    describe "me page" do
      background { visit user_path(inactive_user) }
      it { should have_current_path(activate_path) }
    end

    describe "activate page" do
      background { visit activate_path }
      it { should have_content("Your profile, photos, conversations, and likes are not visible to other members. Activate your account to connect with others on Roozam.") }
      scenario "activating the user" do
        expect { click_button 'Activate' }.to change { User.active.count }.by(1)
      end
    end
  end


  context "active user" do
    subject { page }
    let(:user) { create(:member) }
    background do
      visit login_path
      login(user)
      visit activate_path
    end

    it { should have_current_path(user_path(user)) }

    scenario "deactivating the user" do
      visit account_settings_path
      expect { click_button 'Deactivate my profile' }.to change { User.inactive.count }.by(1)
    end
  end
end
