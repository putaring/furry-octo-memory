require 'rails_helper'

feature 'User banning' do

  context "banned user" do
    subject { page }
    let(:banned_user) { create(:banned_user) }
    background do
      visit login_path
      login(banned_user)
    end

    describe "me page" do
      background { visit user_path(banned_user) }
      it { should have_current_path(banned_path) }
    end

    describe "banned page" do
      background { visit banned_path }
      it { should have_content("Account Banned") }
    end
  end


  context "active user" do
    subject { page }
    let(:user) { create(:member) }
    background do
      visit login_path
      login(user)
      visit banned_path
    end

    it { should have_current_path(user_path(user)) }

  end
end
