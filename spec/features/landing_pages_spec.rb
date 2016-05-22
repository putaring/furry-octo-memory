require 'rails_helper'

feature 'Landing page' do
  background { visit '/welcome/index' }

  scenario 'should display the value proposition' do
    expect(page).to have_content('Find your soul mate for free')
  end

  scenario 'should have the correct title' do
    expect(page).to have_title('Joonam | Find your soul mate for free')
  end
end
