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

  describe "profile details" do
    background { visit user_path(user) }
    it { should have_title("#{user.username} / #{user.age} / #{user.country_name} • Roozam") }
    it { should have_content('21 year old Christian woman') }
    it { should have_content('Mother tongue is English') }
    it { should have_content('Lives in the United States') }
  end

  context "logged out" do
    background { visit user_path(user) }
    it { should have_content('Log in to connect') }
  end

  context "logged in" do
    background do
      visit login_path
      login(create(:user))
      visit user_path(user)
    end
    it { should have_content('Like') }
    it { should have_content('Message') }
  end
end
