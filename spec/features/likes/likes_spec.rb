require 'rails_helper'

feature 'Likes' do
  given(:me)  { create(:registered_user) }
  subject     { page }
  background  { login_as me }
  context 'when there are no likers' do
    background { visit likes_path }
    it { should have_text "You haven't liked anyone yet" }
    it { should have_text "Browse profiles to like people you're interested in." }
    it { should have_link 'Browse profiles', href: search_path }
  end

  context 'when I have liked somebody' do
    given(:match) { create(:registered_user) }
    given(:liked) { create(:registered_user) }

    background do
      create(:interest, liked: liked, liker: me)
      create(:interest, liked: match, liker: liked)
      visit likes_path
    end

    context 'when my like is an active user' do
      subject { page.find('.list-group') }
      it { should have_selector('.list-group-item', count: 1) }
      it { should have_link 'Unlike' }
    end

    context 'when my like is not active' do
      given(:liked) { create(:banned_user) }
      it { should have_text "You haven't liked anyone yet" }
      it { should have_text "Browse profiles to like people you're interested in." }
      it { should have_link 'Browse profiles', href: search_path }
    end

    context 'when my like is a match' do
      subject { page.find('.list-group') }

      given(:match) { me }
      it { should have_selector('.list-group-item', count: 1) }
      it { should have_link 'Unlike' }
    end
  end
end
