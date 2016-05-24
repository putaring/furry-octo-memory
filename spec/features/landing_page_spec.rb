require 'rails_helper'

feature 'Landing page' do
  background { visit root_path }

  scenario 'should display the value proposition' do
    expect(page).to have_content('Find your soul mate for free')
  end

  scenario 'should have the correct title' do
    expect(page).to have_title('Find your soul mate for free | Joonam')
  end
end
