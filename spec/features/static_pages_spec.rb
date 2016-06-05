require 'rails_helper'

feature 'Static pages' do
  background { visit root_path }

  scenario 'should display the value proposition' do
    expect(page).to have_content('Meet your partner now.')
  end

  scenario 'should have the correct title' do
    expect(page).to have_title('Roozam | Meet your partner now')
  end
end
