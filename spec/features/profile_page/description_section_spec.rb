require 'rails_helper'

feature 'Profile description' do
  given(:user) { create(:user) }
  given(:profile) { user.profile }
  given(:profile_attributes) { {} }
  subject { page }

  describe "Viewing the user's description" do
    background { profile.update(profile_attributes) }
    context 'as a visitor' do
      background do
        visit user_path(user)
      end

      it { should have_text 'A few words about me' }
      context "when the user hasn't filled out a description" do
        it { should have_text 'Perhaps a thinker, not a talker.' }
        it { should_not have_link('How would your family describe you?', href: edit_description_path) }

        context 'and is male' do
          given(:user) { create(:user, gender: 'm') }
          it { should have_text "He hasn't written anything yet." }
        end

        context 'and is female' do
          given(:user) { create(:user, gender: 'f') }
          it { should have_text "She hasn't written anything yet." }
        end
      end

      context 'when the user has a filled out description' do
        given(:profile_attributes) { { about: 'This is my description.' } }
        it { should have_text 'This is my description.' }
        it { should_not have_link('Edit', href: edit_description_path) }
      end
    end

    context 'as self' do
      background do
        login_as user
        visit user_path(user)
      end
      it { should have_text 'A few words about me' }
      context "when the user hasn't filled out a description" do
        it { should have_link('How would your family describe you?', href: edit_description_path) }
      end

      context 'when the user has a filled out description' do
        given(:profile_attributes) { { about: 'This is my description.' } }
        it { should have_text 'This is my description.' }
        it { should have_link('Edit', href: edit_description_path) }
      end
    end
  end
end
