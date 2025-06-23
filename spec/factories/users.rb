FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8) }
    role { 'user' }
    active { true }
    confirmed_at { Time.current }

    before(:create, &:skip_confirmation!)

    trait :supervisor do
      role { 'supervisor' }
    end

    trait :inactive do
      active { false }
    end
  end

  sequence :unique_email do |n|
    "user#{n}@example.com"
  end
end
