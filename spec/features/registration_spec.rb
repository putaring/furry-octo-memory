require 'rails_helper'

feature "Registration" do

  describe "Signing up" do
    background { visit signup_path }
    given(:submit) { "Create my account" }

    context "with invalid information" do
      scenario "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    context "with valid information" do
      background do
        select '1980',            from: 'user_birthdate_1i'
        select 'Jan',             from: 'user_birthdate_2i'
        select '31',              from: 'user_birthdate_3i'
        select "I'm a woman",      from: 'Gender'
        select 'Hindu',           from: 'Religion'
        select 'India',           from: 'Where do you live?'
        select 'Malayalam',       from: 'Mother tongue'
        fill_in 'user_email',     with: Faker::Internet.email
        fill_in 'user_password',  with: Faker::Internet.password
      end
      scenario "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  describe "Sign up page" do
    context "when logged in" do
      background do
        visit login_path
        login(create(:user))
      end

      it "should redirect to user landing page" do
        visit signup_path
        expect(page).to have_current_path(me_path)
      end
    end

    context "when not logged in" do
      it "should display the sign up page to the user" do
        visit signup_path
        expect(page).to have_current_path(signup_path)
      end
    end
  end
end
