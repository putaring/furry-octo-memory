require 'rails_helper'

feature 'Profile work section' do
  given(:user) { create(:user) }
  subject { page }

  describe "Viewing the user's description" do
    context 'as a visitor' do
      background { visit user_path(user) }
      it { should have_text "What I'm doing with my life" }
      context "when the user hasn't filled out their work" do
        it { should_not have_link('What are you working towards right now?', href: edit_work_path) }

        context 'and is male' do
          given(:user) { create(:user, gender: 'm') }
          it { should have_text "He hasn't updated this section." }
        end

        context 'and is female' do
          given(:user) { create(:user, gender: 'f') }
          it { should have_text "She hasn't updated this section." }
        end
      end

      context 'when the user has a filled out their work' do
        given(:user) { create(:profile, occupation: 'This is my work.').user }
        it { should have_text 'This is my work.' }
        it { should_not have_link('Edit', href: edit_work_path) }
      end
    end

    context 'as self' do
      background do
        login_as user
        visit user_path(user)
      end
      it { should have_text "What I'm doing with my life" }
      context "when the user hasn't filled out their work" do
        it { should have_link('What are you working towards right now?', href: edit_work_path) }
      end

      context 'when the user has a filled out their work' do
        given(:user) { create(:profile, occupation: 'This is my work.').user }
        it { should have_text 'This is my work.' }
        it { should have_link('Edit', href: edit_work_path) }
      end
    end
  end
end
