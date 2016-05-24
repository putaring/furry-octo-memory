require 'rails_helper'

feature 'Signup page' do
  background { visit signup_path }

  scenario 'should display the signup heading' do
    expect(page).to have_title('Create your account')
  end

end
