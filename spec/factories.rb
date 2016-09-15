FactoryGirl.define do
  factory :user, aliases: [:sender, :recipient] do
    gender        { 'f' }
    birthdate     { 21.years.ago }
    religion      { User.religions.keys.sample }
    language      { LanguageList::COMMON_LANGUAGES.map(&:iso_639_3).sample }
    country       { Faker::Address.country_code }
    email         { Faker::Internet.email }
    password      { Faker::Internet.password }
  end

  factory :restricted_user, parent: :user do
    photo_visibility 'restricted'
  end

  factory :members_only_user, parent: :user do
    photo_visibility 'members_only'
  end

  factory :conversation do
    sender
    recipient
  end

  factory :photo do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'photos', 'jesus_large.png')) }
    user
  end
end
