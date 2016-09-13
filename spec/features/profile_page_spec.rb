require 'rails_helper'

feature "Profile page" do
  let(:user) { create(:user, gender: 'f', country: 'US', birthdate: 21.years.ago, language: 'eng', religion: "christian") }
  subject { page }


  describe "about me" do
    context "empty about me essay" do
      background { visit user_path(user) }
      it { should have_content("Perhaps a thinker, not a talker.")}
    end

    context "non-empty about me essay" do
      let(:user) { create(:user) }
      background do
        user.profile.update_attributes(about: 'Lorem ipsum')
        visit user_path(user)
      end

      it { should have_content('Lorem ipsum') }
    end
  end
end
