require 'rails_helper'

feature 'Static pages' do
  background { visit root_path }

  scenario 'should display the value proposition' do
    expect(page).to have_content('Matchmaking made easy')
  end

  scenario 'should have the correct title' do
    expect(page).to have_title('Joonam | Find your match for free')
  end
end