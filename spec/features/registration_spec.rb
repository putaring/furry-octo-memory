require 'rails_helper'

feature "Registration" do
    given(:year_of_birth) { '1980' }
    given(:user_email)    { Faker::Internet.email }
    given(:user_password) { Faker::Internet.password }
    subject { page }

    background do
      visit signup_path

      select year_of_birth,     from: 'user_birthdate_1i'
      select 'Dec',             from: 'user_birthdate_2i'
      select '31',              from: 'user_birthdate_3i'
      select "I'm a man",       from: 'Gender'
      select 'Hindu',           from: 'Religion'
      select "Unmarried",       from: "Marital status"
      select 'India',           from: 'Where do you live?'
      select 'Malayalam',       from: 'Mother tongue'
      select '6 ft',            from: 'Height'
      fill_in 'user_email',     with: user_email
      fill_in 'user_password',  with: user_password
    end

    context "with valid user information" do
      context 'and terms checkbox is unchecked' do
        background do
          uncheck       'user_terms'
          click_button  'Create account'
        end

        it 'should not create a new user' do
          expect(User.count).to eq 0
        end

        it { should have_current_path(users_path) }
        it { should have_text 'Terms must be accepted' }
      end
      context 'and terms checkbox is checked' do
        background do
          check         'user_terms'
          click_button  'Create account'
        end

        it 'should create a new user' do
          expect(User.count).to eq 1
        end

        it { should have_current_path(verify_path) }
      end
    end

    context 'with invalid user information' do
      background do
        check         'user_terms'
        click_button  'Create account'
      end
      context 'when the user is underage' do
        given(:year_of_birth) { 19.years.ago.year }
        it { should have_text "Birthdate indicates that you're underage" }
      end

      context 'when the password is malformed' do
        given(:user_password) { '12345' }
        it { should have_text "Password is too short" }
      end
    end

end
