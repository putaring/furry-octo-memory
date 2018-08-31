require 'rails_helper'

feature 'Profile preference' do
  given(:user) { create(:registered_user) }
  given(:profile) { user.profile }
  given(:profile_attributes) { {} }
  subject { page }

  describe "Viewing the user's preference" do
    background { profile.update(profile_attributes) }
    context 'as a visitor' do
      background { visit user_path(user) }
      it { should have_text "What I'm actually looking for" }
      context "when the user hasn't filled out their preference" do
        it { should_not have_link('What are you looking for in a partner?', href: edit_preference_path) }
        it { should have_text 'Nothing here yet.' }
      end

      context 'when the user has a filled out their preference' do
        given(:profile_attributes) { { preference: 'This is my preference.' } }
        it { should have_text 'This is my preference.' }
        it { should_not have_link('Edit', href: edit_preference_path) }
      end
    end

    context 'as self' do
      background do
        login_as user
        visit user_path(user)
      end
      it { should have_text "What I'm actually looking for" }
      context "when the user hasn't filled out their preference" do
        it { should have_link('What are you looking for in a partner?', href: edit_preference_path) }
        it { should have_text "No judgement. We're here to help."}
      end

      context 'when the user has a filled out their preference' do
        given(:profile_attributes) { { preference: 'This is my preference.' } }
        it { should have_text 'This is my preference.' }
        it { should have_link('Edit', href: edit_preference_path) }
      end
    end
  end
end
