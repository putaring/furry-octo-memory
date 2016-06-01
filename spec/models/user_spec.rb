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
    it { should validate_length_of(:password).is_at_least(8) }
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
  end

  context 'when email is uppercase' do
    let(:upcase_email)  { Faker::Internet.email.upcase }
    let(:user)          { create(:user, email: upcase_email) }
    it 'should downcase email before saving to the database' do
      expect(user.email).to eq upcase_email.downcase
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
