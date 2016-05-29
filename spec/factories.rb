FactoryGirl.define do
  factory :user do
    gender        'm'
    birthdate     { 18.years.ago }
    religion      'hindu'
    language      'ml'
    country       { Faker::Address.country_code }
    username      { Faker::Internet.user_name }
    email         { Faker::Internet.email }
    password      { Faker::Internet.password }
  end
end
