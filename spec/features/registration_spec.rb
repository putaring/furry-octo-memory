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
        select "I'm female",      from: 'Gender'
        select 'Hindu',           from: 'Religion'
        select 'India',           from: 'Location'
        select 'Malayalam',       from: 'Mother tongue'
        fill_in 'user_email',     with: Faker::Internet.email
        fill_in 'user_password',  with: Faker::Internet.password
      end
      scenario "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
