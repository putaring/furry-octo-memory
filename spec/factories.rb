FactoryGirl.define do
  factory :user, aliases: [:member, :sender, :recipient, :bookmarker, :bookmarked, :reporter, :reported] do
    gender          'f'
    birthdate       21.years.ago
    height          72
    religion        User.religions.keys.sample
    status          'unmarried'
    language        LanguageList::POPULAR_LANGUAGES.map(&:iso_639_3).sample
    country         "IN"
    email           { Faker::Internet.email }
    password        Faker::Internet.password
    ip              "127.0.0.1"
    account_status  'active'
  end

  factory :registered_user, parent: :user, aliases: [:liker, :liked] do
    after(:create) do |user|
      user.create_profile!
      user.create_email_preference!
    end
  end

  factory :unverified_user, parent: :registered_user do
    account_status 'unverified'
  end

  factory :inactive_user, parent: :registered_user do
    account_status 'inactive'
  end

  factory :admin_user, parent: :registered_user do
    account_status 'admin'
  end

  factory :banned_user, parent: :registered_user do
    account_status 'banned'
  end

  factory :restricted_user, parent: :registered_user do
    photo_visibility 'restricted'
  end

  factory :members_only_user, parent: :registered_user do
    photo_visibility 'members_only'
  end

  factory :brahmin, parent: :registered_user do
    religion 'hindu'
    sect 'brh'
  end

  factory :profile do
    user
  end

  factory :email_preference, aliases: [:active_email_account] do
    user

    trait :disabled_notifications do
      receive_notifications false
    end
    trait :bounced do
      status 'permanent_bounce'
    end

    factory :disabled_notifications_account,  traits: [:disabled_notifications]
    factory :permanent_bounce_account,        traits: [:bounced]
    factory :disabled_and_bounced_account,    traits: [:disabled_notifications, :bounced]
  end

  factory :conversation do
    sender
    recipient
  end

  factory :message do
    body  { Faker::Lorem.sentence }
    ip    { "127.0.0.1" }
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
    image { File.open(Rails.root.join('spec/support/photos/faces.jpg')) }
    user
    ip { "127.0.0.1" }
  end

  factory :avatar do
    image { File.open(Rails.root.join('spec/support/photos/faces.jpg')) }
    user
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

  factory :verified_number, parent: :phone_verification do
    verified true
  end
end
