require 'rails_helper'

RSpec.shared_examples "an unrestricted photo album" do
  it { should have_selector('.photo-gallery img', count: 3) }
  it { should have_text 'Showing 3 of 4 photos' }
  it { should have_link 'View all' }
end

RSpec.shared_examples "an empty photo album" do
  it { should_not have_selector('.photo-gallery img') }
  it { should_not have_text 'Showing 3 of 4 photos' }
  it { should_not have_link 'View all' }
end

RSpec.shared_examples "a restricted photo album" do
  it_behaves_like "an empty photo album"
  it { should have_text 'Restricted to members she likes.' }
end


feature 'Profile album section' do
  given(:photo_count) { 0 }
  given(:user) { create(:registered_user, gender: 'f') }
  given(:visitor) { create(:registered_user) }
  subject { page }

  describe "Previewing the user's photo album" do
    background do
      create_list(:photo, photo_count, user: user)
      login_as visitor if visitor.present?
      visit user_path(user)
    end

    it { should have_text "Photo album" }

    context "when the user has no photos" do
      it { should have_text "Album is empty."}
      context 'and is logged in as a visitor' do
        it { should_not have_link('Add photos', href: photos_path) }
      end

      context 'and is logged in as self' do
        given(:visitor) { user }
        it { should have_link('Add photos', href: photos_path) }
      end
    end

    context 'when the user has photos' do
      given(:photo_count) { 4 }
      it { should have_text "Photo album" }
      context 'and is logged in as a visitor' do
        it { should_not have_link "Photo album", href: photos_path }
      end

      context 'and is logged in as self' do
        given(:visitor) { user }
        it { should have_link "Photo album", href: photos_path }
      end


      context 'when photos are public' do
        context 'and is not logged in' do
          given(:visitor) { nil }
          it_behaves_like "an unrestricted photo album"
        end

        context 'and is logged in as a visitor' do
          it_behaves_like "an unrestricted photo album"
        end

        context 'and is logged in as self' do
          given(:visitor) { user }
          it_behaves_like "an unrestricted photo album"
        end
      end

      context 'when photos are restricted to members' do
        given(:user) { create(:members_only_user) }

        context 'and is not logged in' do
          given(:visitor) { nil }
          it_behaves_like "an empty photo album"
          it { should have_text 'Log in to view photos' }
        end

        context 'and is logged in as a visitor' do
          it_behaves_like "an unrestricted photo album"
        end

        context 'and is logged in as self' do
          given(:visitor) { user }
          it_behaves_like "an unrestricted photo album"
        end
      end

      context 'when photos are restricted to likes' do
        given(:user) { create(:restricted_user) }
        context 'and is logged in as a visitor' do
          context 'when the user has expressed interest in the visitor' do
            given(:visitor) { create(:interest, liker: user).liked }
            it_behaves_like "an unrestricted photo album"
          end

          context 'when the user has not expressed interest in the visitor' do
            it_behaves_like "a restricted photo album"
          end

          context 'and is not logged in' do
            given(:visitor) { nil }
            it_behaves_like "an empty photo album"
          end
        end

        context 'and is logged in as self' do
          given(:visitor) { user }
          it_behaves_like "an unrestricted photo album"
        end
      end
    end
  end
end
