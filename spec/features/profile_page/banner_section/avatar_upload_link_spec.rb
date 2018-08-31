require 'rails_helper'

feature 'Avatar upload link' do
  given(:user) { create(:registered_user) }
  subject(:banner_section) { page.find('.jumbotron') }

  context 'as an anonymous user' do
    background { visit user_path(user) }
    it { should_not have_css('[data-toggle="avatar-uploader"]') }
  end

  context 'as a logged in user' do
    background do
      login_as visitor
      visit user_path(user)
    end

    context 'and is a visitor' do
      let(:visitor) { create(:registered_user) }
      it { should_not have_css('[data-toggle="avatar-uploader"]') }
    end

    context 'and is self' do
      let(:visitor) { user }
      it { should have_css('[data-toggle="avatar-uploader"]') }

      context 'and has no avatar' do
        subject(:avatar_link) { page.find('[data-toggle="avatar-uploader"]') }
        it { should have_text 'Add profile photo' }
      end

      context 'and has an avatar' do
        subject(:avatar_link) { page.find('[data-toggle="avatar-uploader"]') }
        before do
          create(:avatar, user: user)
          visit user_path(user)
        end
        context 'that has not been processed' do
          it { should have_text 'Cropping photo…' }
        end

        context 'that has been processed and stored' do
          before do
            user.avatar.image_attacher.promote
            visit user_path(user)
          end
          it { should have_text 'Change photo' }
        end
      end
    end
  end
end
