FactoryBot.define do
  factory :answer do
    association :question
    content { Faker::Lorem.sentence }
    is_correct { false }

    trait :correct do
      is_correct { true }
    end
  end
end
