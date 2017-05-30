FactoryGirl.define do
  factory :user, aliases: [:unverified_user] do
    gender        { 'f' }
    birthdate     { 21.years.ago }
    height        { 72 }
    religion      { User.religions.keys.sample }
    status        { 'unmarried' }
    language      { LanguageList::POPULAR_LANGUAGES.map(&:iso_639_3).sample }
    country       { Faker::Address.country_code }
    email         { Faker::Internet.email }
    password      { Faker::Internet.password }
  end

  factory :active_user, parent: :user, aliases: [:member, :sender, :recipient, :liker, :liked, :bookmarker, :bookmarked, :reporter, :reported] do
    account_status 'active'
  end

  factory :brahmin, parent: :active_user do
    religion 'hindu'
    sect 'brh'
  end

  factory :restricted_user, parent: :active_user do
    photo_visibility 'restricted'
  end

  factory :members_only_user, parent: :active_user do
    photo_visibility 'members_only'
  end

  factory :inactive_user, parent: :user do
    account_status 'inactive'
  end

  factory :admin_user, parent: :user do
    account_status 'admin'
  end

  factory :banned_user, parent: :user do
    account_status 'banned'
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

  factory :bookmark do
    bookmarker
    bookmarked
  end

  factory :photo do
    user
  end

  factory :active_photo, parent: :photo do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'photos', 'jesus_large.png')) }
    status 'active'
  end

  factory :report do
    reporter
    reported
    reason   { 'inappropriate_photo' }
  end

  factory :resolved_report, parent: :report do
    resolved true
  end

  factory :phone_verification do
    phone_number  { "+13109009000" }
    ip            { "127.0.0.1" }
    user
  end
end
