require 'rails_helper'

RSpec.describe AvatarHelper, type: :helper do

  let(:gender) { 'f' }
  let(:photo_visibility) { 'everyone' }
  let(:user) { create(:registered_user, gender: gender, photo_visibility: photo_visibility) }
  let(:visitor) { create(:registered_user) }

  describe '#default_avatar_for' do
    context 'when the user is male' do
      let(:gender) { 'm' }
      it 'should return the male default avatar' do
        expect(helper.default_avatar_for(user)).to include 'profile_pictures/male'
      end
    end

    context 'when the user is female' do
      let(:gender) { 'f' }
      it 'should return the female default avatar' do
        expect(helper.default_avatar_for(user)).to include 'profile_pictures/female'
      end
    end
  end

  describe '#avatar_for' do
    context 'when the user has uploaded an avatar' do
      before { create(:avatar, user: user) }
      let(:gender) { 'f' }
      context 'when the avatar is cached' do
        it 'should return the default avatar' do
          expect(helper.avatar_for(user)).to include 'profile_pictures/female'
        end
      end

      context 'when the avatar is stored' do
        before { user.avatar.image_attacher.promote }
        it 'should return the uploaded avatar' do
          expect(helper.avatar_for(user)).to eq user.avatar.image_url(:large)
        end
      end
    end

    context 'when the user has not uploaded an avatar' do
      let(:gender) { 'm' }
      it 'should return the default avatar' do
        expect(helper.avatar_for(user)).to include 'profile_pictures/male'
      end
    end
  end

  describe '#display_picture_for' do
    let(:gender) { 'm' }
    let(:display_picture_url) { helper.display_picture_for(user, visitor) }

    context 'when the user has uploaded an avatar' do
      before do
        create(:avatar, user: user)
        user.avatar.image_attacher.promote
      end

      context 'when user photos are restricted' do
        let(:photo_visibility) { 'restricted' }
        context 'when visitor is not logged in' do
          let(:visitor) { nil }
          it 'should return the default avatar' do
            expect(display_picture_url).to include 'profile_pictures/male'
          end
        end

        context 'when visitor is not a like' do
          let(:visitor) { create(:registered_user) }
          it 'should return the default avatar' do
            expect(display_picture_url).to include 'profile_pictures/male'
          end
        end

        context 'when visitor is a like' do
          let(:visitor) { create(:interest, liker: user).liked }
          it 'should return the uploaded avatar' do
            expect(display_picture_url).to eq user.avatar.image_url(:large)
          end
        end

        context 'when visitor is self' do
          let(:visitor) { user }
          it 'should return the uploaded avatar' do
            expect(display_picture_url).to eq user.avatar.image_url(:large)
          end
        end
      end

      context 'when user photos are member-only' do
        let(:photo_visibility) { 'members_only' }
        context 'when visitor is not logged in' do
          let(:visitor) { nil }
          it 'should return the default avatar' do
            expect(display_picture_url).to include 'profile_pictures/male'
          end
        end

        context 'when visitor is not a like' do
          let(:visitor) { create(:registered_user) }
          it 'should return the uploaded avatar' do
            expect(display_picture_url).to eq user.avatar.image_url(:large)
          end
        end

        context 'when visitor is a like' do
          let(:visitor) { create(:interest, liker: user).liked }
          it 'should return the uploaded avatar' do
            expect(display_picture_url).to eq user.avatar.image_url(:large)
          end
        end

        context 'when visitor is self' do
          let(:visitor) { user }
          it 'should return the uploaded avatar' do
            expect(display_picture_url).to eq user.avatar.image_url(:large)
          end
        end
      end

      context 'when user photos are public' do
        let(:photo_visibility) { 'everyone' }
        context 'when visitor is not logged in' do
          let(:visitor) { nil }
          it 'should return the uploaded avatar' do
            expect(display_picture_url).to eq user.avatar.image_url(:large)
          end
        end

        context 'when visitor is not a like' do
          let(:visitor) { create(:registered_user) }
          it 'should return the uploaded avatar' do
            expect(display_picture_url).to eq user.avatar.image_url(:large)
          end
        end

        context 'when visitor is a like' do
          let(:visitor) { create(:interest, liker: user).liked }
          it 'should return the uploaded avatar' do
            expect(display_picture_url).to eq user.avatar.image_url(:large)
          end
        end

        context 'when visitor is self' do
          let(:visitor) { user }
          it 'should return the uploaded avatar' do
            expect(display_picture_url).to eq user.avatar.image_url(:large)
          end
        end
      end

    end
  end

end
