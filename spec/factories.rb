FactoryGirl.define do
  factory :user, aliases: [:sender, :recipient, :liker, :liked] do
    gender        { 'f' }
    birthdate     { 21.years.ago }
    height        { 72 }
    religion      { User.religions.keys.sample }
    language      { LanguageList::POPULAR_LANGUAGES.map(&:iso_639_3).sample }
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

  factory :message do
    body { Faker::Lorem.sentence }
    sender
    recipient
    conversation
  end

  factory :interest do
    liker
    liked
  end

  factory :photo do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'photos', 'jesus_large.png')) }
    user
  end
end
