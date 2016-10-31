require 'rails_helper'

feature 'Photos page' do
  let(:user) { create(:user) }
  subject { page }
  background do
    visit login_path
    login(user)
    visit photos_path
  end

  it { should have_content('Photos of me') }

  context "No photos uploaded" do
    it { should have_content("You haven't added any photos.") }
    it { should have_content("Most women on Roozam have a photo. Adding a photo greatly increases your chances of being contacted by a match.") }
    it { should have_content("Upload photo") }
  end

  context "Has profile photo" do
    before do
      create(:photo, user: user)
      visit photos_path
    end

    it { should have_content("Upload photo") }
    it { should have_content("Delete") }

    it "should delete a photo successfully" do
      expect { click_link "Delete" }.to change {Photo.count}.from(1).to(0)
    end
  end

  context "Has multiple photos" do
    before do
      create(:photo, user: user)
      create(:photo, user: user)
      visit photos_path
    end
  end

end
