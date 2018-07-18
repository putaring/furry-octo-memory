require 'rails_helper'
feature "Navbar" do
  let(:profile) { create(:user) }
  subject(:navbar) { page.find('.navbar.fixed-top') }

  background do
    login_as visitor if visitor.present?
    visit user_path(profile)
  end

  context "when logged in" do
    given(:visitor) { create(:user) }
    it { should have_link('Spouzz', href: user_path(visitor)) }

    it { should have_link('Browse', href: search_path) }


    it { should have_link('My profile', href: user_path(visitor)) }
    it { should have_link('Messages', href: messages_path) }
    it { should have_link('Likes', href: likes_path) }
    it { should have_link('Settings', href: email_settings_path) }
    it { should have_link('Log out', href: logout_path) }
  end

  context "when logged out" do
    given(:visitor) { nil }
    it { should have_link('Spouzz', href: root_path) }

    it { should have_link('Log in', href: login_path) }
    it { should have_link('Sign up', href: signup_path) }
  end
end
