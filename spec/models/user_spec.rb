require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    subject { build(:user) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to validate_presence_of(:religion) }
    it { is_expected.to validate_presence_of(:language) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:username).on(:update) }

    it { is_expected.to validate_numericality_of(:height).is_greater_than(24).only_integer }
    it { is_expected.to validate_numericality_of(:income).allow_nil }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

    it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(30).on(:update) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to validate_length_of(:language).is_equal_to(3) }
    it { is_expected.to validate_length_of(:country).is_equal_to(2) }

    it { is_expected.to validate_inclusion_of(:gender).in_array(%w(m f)) }
    #it { is_expected.to validate_inclusion_of(:sect).in_array(CASTES.collect { |c| c[:code] }).allow_nil }
    it { is_expected.to validate_inclusion_of(:language).in_array(LanguageList::POPULAR_LANGUAGES.map(&:iso_639_3)) }
    it { is_expected.to validate_inclusion_of(:country).in_array(ISO3166::Data.codes) }

    it { is_expected.to validate_acceptance_of(:terms) }

    it { is_expected.to allow_values(Faker::Internet.email).for(:email) }
    it { is_expected.to allow_value(Faker::Date.between(100.years.ago, 18.years.ago + 1.day)).for(:birthdate) }

    it { is_expected.to_not allow_values('faker_at_example.com').for(:email) }
    it { is_expected.to_not allow_value(Faker::Date.between(18.years.ago + 1.day, Date.today)).for(:birthdate) }

    it { is_expected.to have_secure_password }

    it { is_expected.to have_many(:photos) }
    it { is_expected.to have_many(:sent_messages) }
    it { is_expected.to have_many(:received_messages) }
    it { is_expected.to have_many(:active_interests) }
    it { is_expected.to have_many(:passive_interests) }
    it { is_expected.to have_many(:likes) }
    it { is_expected.to have_many(:likers) }
    it { is_expected.to have_many(:active_visits) }
    it { is_expected.to have_many(:passive_visits) }
    it { is_expected.to have_many(:visits) }
    it { is_expected.to have_many(:visitors) }
    it { is_expected.to have_many(:active_bookmarks) }
    it { is_expected.to have_many(:passive_bookmarks) }
    it { is_expected.to have_many(:favorites) }
    it { is_expected.to have_many(:favoriters) }
    it { is_expected.to have_many(:phone_verifications) }
    it { is_expected.to have_one(:profile) }
    it { is_expected.to have_one(:email_preference) }
  end

  describe "likes?(other_user)" do
    let(:user)        { create(:member) }
    let(:other_user)  { create(:member) }
    before { user.like(other_user) }

    it "returns true if you like a user" do
      expect(user.likes?(other_user)).to be true
    end

    it "returns false if you don't like a user" do
      expect(other_user.likes?(user)).to be false
    end
  end


  describe "bookmarked?(other_user)" do
    let(:user)        { create(:member) }
    let(:other_user)  { create(:member) }
    before { user.favorite(other_user) }

    it "returns true if you have bookmarked a user" do
      expect(user.bookmarked?(other_user)).to be true
    end

    it "returns false if you haven't bookmarked a user" do
      expect(other_user.bookmarked?(user)).to be false
    end
  end

  describe "#favorite(user)" do
    it "should allow the user to favorite another user" do
      user       = create(:member)
      other_user = create(:member)
      user.favorite(other_user)
      expect(user.favorites.count).to eq(1)
      expect(other_user.favoriters.count).to eq(1)
    end
  end

  describe "#unfavorite(user)" do
    it "should allow the user to unfavorite another user" do
      user       = create(:member)
      other_user = create(:member)
      create(:bookmark, bookmarker: user, bookmarked: other_user)
      user.unfavorite(other_user)
      expect(user.favorites.count).to eq(0)
      expect(other_user.favoriters.count).to eq(0)
    end
  end

  describe "#like(user)" do
    it "should allow the user to like another user" do
      user       = create(:member)
      other_user = create(:member)
      user.like(other_user)
      expect(user.likes.count).to eq(1)
      expect(other_user.likers.count).to eq(1)
    end
  end

  describe "#unlike(user)" do
    it "should allow the user to unlike a liked user" do
      user       = create(:member)
      other_user = create(:member)
      create(:interest, liker: user, liked: other_user)
      user.unlike(other_user)
      expect(user.likes.count).to eq(0)
      expect(other_user.likers.count).to eq(0)
    end
  end

  describe "#decline(user)" do
    it "should remove all interests between the users" do
      user        = create(:member)
      other_user  = create(:member)
      create(:interest, liker: other_user, liked: user)
      create(:interest, liked: other_user, liker: user)
      user.decline(other_user)
      expect(user.likers.count).to eq(0)
      expect(user.likes.count).to eq(0)
    end
  end


  describe "#display_photos_to?(user)" do

    context "photo visibility is restricted" do
      let(:user) { create(:restricted_user) }

      specify { expect(user.display_photos_to?(nil)).to be false }
      specify { expect(user.display_photos_to?(create(:registered_user))).to be false }
      specify { expect(user.display_photos_to?(user)).to be true }

      it "should display photos to liked members" do
        liked = create(:liked)
        create(:interest, liker: user, liked: liked)
        expect(user.display_photos_to?(liked)).to be true
      end
    end

    context "photo visibility is members only" do
      let(:user) { create(:members_only_user) }
      specify { expect(user.display_photos_to?(nil)).to be false }
      specify { expect(user.display_photos_to?(create(:registered_user))).to be true }
    end

    context "photo visibility is public" do
      let(:user) { create(:registered_user) }
      specify { expect(user.display_photos_to?(nil)).to be true }
      specify { expect(user.display_photos_to?(create(:registered_user))).to be true }
    end
  end

  describe "#gender_expanded" do
    specify { expect(create(:registered_user, gender: 'm').gender_expanded).to eq('groom') }
    specify { expect(create(:registered_user, gender: 'f').gender_expanded).to eq('bride')}
  end

  describe "#age" do
    it "should return the age of the user" do
      expect(create(:registered_user, birthdate: 34.years.ago).age).to eq(34)
    end
  end

  describe "#male?" do
    let(:male)    { create(:registered_user, gender: 'm') }
    let(:female)  { create(:registered_user, gender: 'f') }

    it "should return true for a male user" do
      expect(male.male?).to be true
    end

    it "should return false for a female user" do
      expect(female.male?).to be false
    end
  end

  describe "#female?" do
    let(:male)    { create(:registered_user, gender: 'm') }
    let(:female)  { create(:registered_user, gender: 'f') }

    it "should return true for a female user" do
      expect(female.female?).to be true
    end

    it "should return false for a male user" do
      expect(female.male?).to be false
    end
  end

  context 'when email is uppercase' do
    let(:upcase_email)  { Faker::Internet.email.upcase }
    let(:user)          { create(:registered_user, email: upcase_email) }
    it 'should downcase email before saving to the database' do
      expect(user.email).to eq upcase_email.downcase
    end
  end

  context 'when a male is underage' do
    let(:user) { build(:user, gender: 'm', birthdate: 20.years.ago) }
    it 'should not be valid' do
      expect(user).to be_invalid
    end
  end

  context 'when username is uppercase' do
    let(:upcase_username)   { Faker::Internet.user_name.upcase }
    let(:user)              { create(:registered_user) }
    it 'should downcase username before saving to the database' do
      user.update_attributes(username: upcase_username)
      expect(user.reload.username).to eq upcase_username.downcase
    end
  end

  context 'when username is not provided' do
    let(:user) { create(:registered_user, username: nil) }
    it 'should create a username before saving to the database' do
      expect(user.username).to be_present
    end
  end

  context "change religion" do
    it "should reset caste to nil if religion is not hindu" do
      brahmin = create(:brahmin)
      expect(brahmin.sect).to eq('brh')
      brahmin.update_attributes(religion: 'muslim')

      expect(brahmin.reload.sect).to be_nil
    end
  end

end
