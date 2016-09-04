FactoryGirl.define do
  factory :user do
    gender        { 'f' }
    birthdate     { 21.years.ago }
    religion      { User.religions.keys.sample }
    language      { LanguageList::COMMON_LANGUAGES.map(&:iso_639_3).sample }
    country       { Faker::Address.country_code }
    email         { Faker::Internet.email }
    password      { Faker::Internet.password }
  end

  factory :photo do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'photos', 'jesus_large.png')) }
    user
  end
end
