require 'rails_helper'

feature 'Likers' do
  given(:me)  { create(:registered_user) }
  subject     { page }
  background  { login_as me }
  context 'when there are no likers' do
    background { visit likers_path }
    it { should have_text 'No likers yet' }
    it { should have_text "Browse profiles to like people you're interested in." }
    it { should have_link 'Browse profiles', href: search_path }
  end

  context 'when I have a liker' do
    given(:match) { create(:registered_user) }
    given(:liker) { create(:registered_user) }

    background do
      create(:interest, liked: me, liker: liker)
      create(:interest, liked: match, liker: me)
      visit likers_path
    end

    context 'when my liker is an active user' do
      it { should have_selector('.list-group-item', count: 1) }
      it { should have_link 'Accept' }
      it { should have_link 'Decline' }
    end

    context 'when my liker is not active' do
      given(:liker) { create(:banned_user) }
      it { should have_text 'No likers yet' }
      it { should have_text "Browse profiles to like people you're interested in." }
      it { should have_link 'Browse profiles', href: search_path }
    end

    context 'when my liker is a match' do
      given(:match) { liker }
      it { should have_selector('.list-group-item', count: 1) }
      it { should have_no_link 'Accept' }
      it { should have_text 'Accepted' }
      it { should have_link 'Decline' }
    end
  end
end
