require 'rails_helper'

feature 'Onboarding' do

  describe "User Photo" do
    context "when user is logged in" do
      let(:user) { create(:user) }
      background do
        visit login_path
        login(user)
        visit onboarding_photo_path
      end

      context "when the user is male" do
        let(:user) { create(:user, gender: 'm') }
        it "should display content tagetted toward males" do
          expect(page).to have_content('Want women to notice you? Add a photo.')
          expect(page).to have_content('Most men on Roozam have a photo. Adding a profile photo greatly increases your chances of being contacted by women.')
        end
      end

      context "when the user is female" do
        let(:user) { create(:user, gender: 'f') }
        it "should display content tagetted toward females" do
          expect(page).to have_content('Want to be noticed? Add a photo.')
          expect(page).to have_content('Most women on Roozam have a photo. Adding a profile photo greatly increases your chances of being contacted by a match.')
        end
      end

      context "when the user has a photo" do
        let(:photo) { create(:photo) }
        let(:user)  { photo.user }
        it "should tell the user that they look great" do
          expect(page).to have_content('You look fantastic.')
        end

        it "should tell the user that their photo is public if they have a public profile" do
          within('.dropdown-toggle')  { expect(page).to have_content('Public') }
        end

        it "should tell the user that their photo is visible only to registered users if they've changes the privacy setting" do
          user.update_attributes(photo_visibility: 'members_only')
          visit onboarding_photo_path
          within('.dropdown-toggle')  { expect(page).to have_content('Members') }
        end

        it "should tell the user that they're photo us blocked to all users except the ones they trust" do
          user.update_attributes(photo_visibility: 'restricted')
          visit onboarding_photo_path
          within('.dropdown-toggle')  { expect(page).to have_content('Restricted') }
        end

      end
    end

    context "when user is logged out" do
      it "should redirect the user to the login page" do
        visit onboarding_photo_path
        expect(page).to have_current_path(login_path)
      end
    end
  end


  describe "User introduction" do
    context "when user is logged in" do
      let(:user) { create(:user) }
      background do
        visit login_path
        login(user)
        visit onboarding_about_path
      end
      it "should prompt the user to introduce themselves" do
        expect(page).to have_css('form textarea')
      end

      it "takes the user to their landing page when the skip link is clicked" do
        click_link 'Skip ➔'
        expect(page).to have_current_path(me_path)
      end

      it "should display an error if the user crosses the character limit" do
        fill_in 'profile_about', with: Faker::Lorem.characters(1501)
        click_button 'Done'
        expect(page).to have_content('maximum is 1500 characters')
      end
    end

    context "when user is logged out" do
      it "should redirect the user to the login page" do
        visit onboarding_about_path
        expect(page).to have_current_path(login_path)
      end
    end
  end
end
