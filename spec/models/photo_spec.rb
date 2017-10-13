require 'rails_helper'

RSpec.describe Photo, type: :model do

  context "validations" do
    it { is_expected.to validate_presence_of(:rank) }
    it { is_expected.to validate_numericality_of(:rank).is_greater_than_or_equal_to(1) }

    it { is_expected.to belong_to(:user) }
  end

  context "ranking" do
    let(:photo)   { create(:photo) }
    let(:photo2)  { create(:photo, user: photo.user) }
    let(:photo3)  { create(:photo, user: photo.user) }

    it "auto ranks photos during creation" do
      expect(photo.rank).to eq(1)
      expect(photo2.rank).to eq(2)
      expect(photo3.rank).to eq(3)
    end

    describe "#make_profile_photo" do
      it "sets the rank of the photo to 1" do
        expect([photo.rank, photo2.rank, photo3.rank]).to eq([1, 2, 3])
        photo2.make_profile_photo
        expect([photo2.reload.rank, photo.reload.rank, photo3.reload.rank]).to eq([1, 2, 3])
      end
    end

    it "auto ranks photos when a rank is updated" do
      expect([photo.rank, photo2.rank, photo3.rank]).to eq([1, 2, 3])
      photo.update_attributes(rank: 2)
      expect([photo2.reload.rank, photo.reload.rank, photo3.reload.rank]).to eq([1, 2, 3])
      photo.update_attributes(rank: 3)
      expect([photo2.reload.rank, photo3.reload.rank, photo.reload.rank]).to eq([1, 2, 3])
      photo.update_attributes(rank: 2)
      expect([photo2.reload.rank, photo.reload.rank, photo3.reload.rank]).to eq([1, 2, 3])
      photo.update_attributes(rank: 1)
      expect([photo.reload.rank, photo2.reload.rank, photo3.reload.rank]).to eq([1, 2, 3])
    end

    it "auto ranks a user's photos after a photo is deleted" do
      expect([photo.rank, photo2.rank, photo3.rank]).to eq([1, 2, 3])
      photo2.destroy
      expect([photo.reload.rank, photo3.reload.rank]).to eq([1, 2])
    end

    it "doesn't allow rank to be exceed total user photos" do
      photo.update_attributes(rank: 4)
      expect(photo).to be_invalid
    end
  end
end
