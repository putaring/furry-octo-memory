FactoryGirl.define do
  factory :user do
    username      { Faker::Internet.user_name }
    email         { Faker::Internet.email }
    password      { Faker::Internet.password }
    date_of_birth { 18.years.ago }
  end
end
