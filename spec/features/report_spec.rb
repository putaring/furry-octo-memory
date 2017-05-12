require 'rails_helper'

feature "Report a user" do

  describe "Reporting a user from the profile page" do
    context "Logged out" do
      it "should not give the user an option report the profile" do
        visit user_path(create(:user))
        expect(page).to_not have_content('Report user')
      end
    end

    context "Logged in" do
      background do
        visit login_path
        login(create(:user))
      end

      it "should give the user an option to report the profile" do
        visit user_path(create(:user))
        within('.jumbotron') { expect(page).to have_content('Report user') }
        within('#report-modal') { expect(page).to have_content('Report user') }
      end

      it "should allow the user to create a report" do
        visit user_path(create(:user))
        expect { click_button "Report this profile" }.to change(Report, :count).by(1)
      end
    end
  end

  describe "Report page" do
    let(:reporter)  { create(:user) }
    let(:reported)  { create(:user) }
    let(:report)    { create(:report, reporter: reporter, reported: reported) }

    context "Logged out" do
      it "should redirect to login page" do
        visit report_path(report)
        expect(page).to have_current_path(login_path)
      end
    end

    context "Logged in" do
      context "Logged in as reporter" do
        background do
          visit login_path
          login(reporter)
          visit report_path(report)
        end

        it "should display the report page" do
          expect(page).to have_current_path(report_path(report))
        end
      end

      context "Logged in as random user" do
        background do
          visit login_path
          login(create(:user))
        end

        it "should not display the report page" do
          expect { visit report_path(report) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

    end

  end

end
