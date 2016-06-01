FactoryGirl.define do
  factory :user do
    gender        { %w(m f).sample }
    birthdate     { 18.years.ago }
    religion      { User.religions.keys.sample }
    language      { LanguageList::COMMON_LANGUAGES.map(&:iso_639_3).sample }
    country       { Faker::Address.country_code }
    email         { Faker::Internet.email }
    password      { Faker::Internet.password }
  end
end
