require 'rails_helper'

feature "Investigate Reports" do
  context "View Reports" do
    background do
      create_list(:report, 3)
      create_list(:resolved_report, 2)
      visit login_path
      login(create(:admin_user))
      visit admin_reports_path
    end

    it "should display unresolved reports" do
      expect(page).to have_selector("tbody tr", count: 3)
    end
  end
end
