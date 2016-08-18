require 'rails_helper'

feature 'Home page' do
  context "when logged out" do
    it "should keep display the home page" do
      visit root_path
      expect(page).to have_current_path(root_path)
    end
  end
end
