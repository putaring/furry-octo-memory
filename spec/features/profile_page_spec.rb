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
        user.profile.update_attributes(about: 'I am a fox')
        visit user_path(user)
      end

      it { should have_content('I am a fox') }
    end

    context "non-empty occupation essay" do
      let(:user) { create(:user) }
      background do
        user.profile.update_attributes(occupation: 'I cook goats')
        visit user_path(user)
      end

      it { should have_content("What I'm doing with my life") }
      it { should have_content('I cook goats') }
    end

    context "non-empty preference essay" do
      let(:user) { create(:user) }
      background do
        user.profile.update_attributes(preference: 'I like goats')
        visit user_path(user)
      end

      it { should have_content("Who should contact me") }
      it { should have_content('I like goats') }
    end
  end

  describe "photo section" do
    context "when the user hasn't uploaded any photos" do
      background { visit user_path(user) }
      it { should have_content("Camera shy, maybe?")}
    end
  end

  describe "profile details" do
    background { visit user_path(user) }
    it { should have_title("#{user.username} | Roozam") }
    it { should have_content('Woman, 21 years, 6 ft, Unmarried') }
    it { should have_content('Mother tongue is English') }
    it { should have_content('Lives in the United States') }
  end

  context "logged out" do
    background { visit user_path(user) }
    it { should have_content('Log in') }
    it { should have_content('Join now') }
  end

  context "logged in viewing a new match" do
    background do
      visit login_path
      login(create(:user))
      visit user_path(user)
    end
    it { should have_content('Like') }
    it { should have_content('Message') }
  end

  context "Logged in and viewing my profile page" do
    background do
      visit login_path
      login(user)
      visit user_path(user)
    end

    context "Empty about me" do
      it { should have_content("About me") }
      it { should have_content("You haven't written anything yet.") }
      it { should have_content("Add a short description") }
    end

    context "Empty occupation" do
      it { should have_content("What I'm doing with my life") }
      it { should have_content("This essay is empty.") }
      it { should have_content("What do you do day-to-day?") }
    end

    context "Empty preference" do
      it { should have_content("Who should contact me") }
      it { should have_content("You haven't mentioned your preference") }
      it { should have_content("Fill it out") }
    end

  end

  context "logged in viewing a match whom you've expressed interest in" do
    background do
      interest = create(:interest)
      visit login_path
      login(interest.liker)
      visit user_path(interest.liked)
    end
    it { should have_content('Unlike') }
  end

  context "logged in viewing ones profile" do
    background do
      visit login_path
      login(user)
      visit user_path(user)
    end
    it { should have_content('Edit profile') }
  end
end
