require 'rails_helper'

feature 'Banner details' do
  given(:user) { create(:brahmin, gender: 'm', birthdate: 21.years.ago, height: 72, status: 'unmarried', language: 'mal', country: "US") }
  subject(:details_section) { page.find('.jumbotron') }

  describe "Visiting the user's profile page" do
    background { visit user_path(user) }
    it { should have_text user.username }
    it { should have_text '21 year-old groom, 6 ft tall, Hindu (Brahmin)' }
    it { should have_text 'Unmarried, Lives in the United States of America' }
    it { should have_text 'Speaks Malayalam' }
  end

end
