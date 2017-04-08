require 'rails_helper'

feature 'Dashboard' do
  let(:user) { create(:user) }
  subject { page }
  before do
    visit login_path
    login(user)
    visit me_path
  end

  context "first time visitor" do
    before { visit me_path(new_user: true) }
    it { should have_content("You're in! Welcome to Roozam.") }
  end

  context "on boarding has not been completed" do
    context "no information has been filled in" do
      it { should have_content("Complete your profile in 2 easy steps.") }
      it { should have_content('Add some photos') }
      it { should have_content('Say something about yourself') }
    end

    context "only about has been filled up" do
      before do
        user.profile.update_attributes(about: Faker::Lorem.sentence)
        visit me_path
      end
      it { should have_content("Add some photos to complete your profile.") }
      it { should have_content('Add some photos') }
      it { should have_content('Say something about yourself') }
    end

    context "only photo has been uploaded" do
      before do
        create(:photo, user: user)
        visit me_path
      end
      it { should have_content("Say something about yourself to complete your profile.") }
      it { should have_content('Add some photos') }
      it { should have_content('Say something about yourself') }
    end
  end

  context "onboarding is completed" do
    before do
      create(:photo, user: user)
      user.profile.update_attributes(about: Faker::Lorem.sentence)
      visit me_path
    end
    it { should have_content('What do you feel like doing today?') }
    it { should have_content('Browse profiles') }
    it { should have_content('View your profile') }
  end
end
