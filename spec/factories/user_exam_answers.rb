FactoryBot.define do
  factory :user_exam_answer do
    association :user_exam_question
    association :answer
    content_text { nil }
    is_correct_at_submission { false }

    trait :correct do
      is_correct_at_submission { true }
    end

    trait :with_text do
      content_text { Faker::Lorem.sentence }
    end

    trait :text_answer do
      answer { nil }
      content_text { Faker::Lorem.paragraph }
    end
  end
end
