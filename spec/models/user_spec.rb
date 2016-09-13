require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    subject(:user) { build(:user) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:birthdate) }
    it { should validate_presence_of(:religion) }
    it { should validate_presence_of(:language) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username).on(:update) }


    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:username).case_insensitive }

    it { should validate_length_of(:username).is_at_least(3).is_at_most(30).on(:update) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_length_of(:language).is_equal_to(3) }
    it { should validate_length_of(:country).is_equal_to(2) }

    it { should validate_inclusion_of(:gender).in_array(%w(m f)) }
    it { should validate_inclusion_of(:language).in_array(LanguageList::COMMON_LANGUAGES.map(&:iso_639_3)) }
    it { should validate_inclusion_of(:country).in_array(ISO3166::Data.codes) }

    it { should allow_values(Faker::Internet.email).for(:email) }
    it { should allow_value(Faker::Date.between(100.years.ago, 18.years.ago + 1.day)).for(:birthdate) }

    it { should_not allow_values('faker_at_example.com').for(:email) }
    it { should_not allow_value(Faker::Date.between(18.years.ago + 1.day, Date.today)).for(:birthdate) }

    it { should have_secure_password }

    it { should have_many(:photos) }
    it { should have_one(:profile) }
  end

  describe "#display_thumbnail" do
    it "should display the profile thumbnail if the user has a profile picture" do
      profile_photo = create(:photo)
      user          = profile_photo.user

      expect(user.display_thumbnail(:thumb)).to eq(profile_photo.image.url(:thumb))
      expect(user.display_thumbnail(:small_thumb)).to eq(profile_photo.image.url(:small_thumb))
    end

    it "should return default url if the user has no photo" do
      user = create(:user, gender: 'f')

      expect(user.display_thumbnail(:thumb)).to eq(ActionController::Base.helpers.asset_path("profile_pictures/female.jpg"))
      expect(user.display_thumbnail(:small_thumb)).to eq(ActionController::Base.helpers.asset_path("profile_pictures/female-small.jpg"))
    end
  end

  describe "#display_photos_to?(user)" do

    context "photo visibility is restricted" do
      let(:user) { create(:restricted_user) }
      specify { expect(user.display_photos_to?(nil)).to be false }
      specify { expect(user.display_photos_to?(create(:user))).to be false }
      specify { expect(user.display_photos_to?(user)).to be true }

      it "should display photos to liked members" do
        skip
      end
    end

    context "photo visibility is members only" do
      let(:user) { create(:members_only_user) }
      specify { expect(user.display_photos_to?(nil)).to be false }
      specify { expect(user.display_photos_to?(create(:user))).to be true }
    end

    context "photo visibility is public" do
      let(:user) { create(:user) }
      specify { expect(user.display_photos_to?(nil)).to be true }
      specify { expect(user.display_photos_to?(create(:user))).to be true }
    end
  end

  describe "#gender_expanded" do
    specify { expect(create(:user, gender: 'm').gender_expanded).to eq('man') }
    specify { expect(create(:user, gender: 'f').gender_expanded).to eq('woman')}
  end

  describe "#profile_photo" do
    it "should return the top ranked photo of the user" do
      profile_photo = create(:photo)
      user          = profile_photo.user
      create(:photo, user: user)

      expect(user.profile_photo).to eq(profile_photo)
    end

    it "should return nil when the user doesn't have an uploaded photo" do
      expect(create(:user).profile_photo).to be_nil
    end
  end

  describe "#age" do
    it "should return the age of the user" do
      expect(create(:user, birthdate: 34.years.ago).age).to eq(34)
    end
  end

  describe "#male?" do
    let(:male)    { create(:user, gender: 'm') }
    let(:female)  { create(:user, gender: 'f') }

    it "should return true for a male user" do
      expect(male.male?).to be true
    end

    it "should return false for a female user" do
      expect(female.male?).to be false
    end
  end

  describe "#female?" do
    let(:male)    { create(:user, gender: 'm') }
    let(:female)  { create(:user, gender: 'f') }

    it "should return true for a female user" do
      expect(female.female?).to be true
    end

    it "should return false for a male user" do
      expect(female.male?).to be false
    end
  end

  context "when a user is created" do
    it "should create a default profile for the user" do
      user  = create(:user)
      expect(user.profile).to be_present
    end
  end

  context 'when email is uppercase' do
    let(:upcase_email)  { Faker::Internet.email.upcase }
    let(:user)          { create(:user, email: upcase_email) }
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
    let(:user)              { create(:user) }
    it 'should downcase username before saving to the database' do
      user.update_attributes(username: upcase_username)
      expect(user.reload.username).to eq upcase_username.downcase
    end
  end

  context 'when username is not provided' do
    let(:user) {  create(:user, username: nil) }
    it 'should create a username before saving to the database' do
      expect(user.username).to be_present
    end
  end
end
