require 'rails_helper'

feature 'Dashboard' do
  let(:user) { create(:user) }
  subject { page }
  before do
    visit login_path
    login(user)
    visit me_path
  end

  context "on boarding has not been completed" do
    context "no information has been filled in" do
      it { should have_content("Get started in 3 easy steps.") }
      it { should have_content('Add some photos') }
      it { should have_content('Fill out your profile') }
      it { should have_content('Browse profiles') }
    end

    context "only about has been filled up" do
      before do
        user.profile.update_attributes(about: Faker::Lorem.sentence)
        visit me_path
      end
      it { should have_content("Get started in 3 easy steps.") }
      it { should have_content('Add some photos') }
      it { should have_content('Fill out your profile') }
      it { should have_content('Browse profiles') }
    end

    context "only photo has been uploaded" do
      before do
        create(:photo, user: user)
        visit me_path
      end
      it { should have_content("Get started in 3 easy steps.") }
      it { should have_content('Add some photos') }
      it { should have_content('Fill out your profile') }
      it { should have_content('Browse profiles') }
    end
  end

  context "onboarding is completed" do
    before do
      create(:photo, user: user)
      user.profile.update_attributes(about: Faker::Lorem.sentence)
      visit me_path
    end
    it { should have_content('What would you like to do today?') }
    it { should have_content('Browse profiles') }
    it { should have_content('View your profile') }
  end
end
