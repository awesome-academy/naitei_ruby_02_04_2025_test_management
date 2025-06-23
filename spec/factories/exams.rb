FactoryBot.define do
  factory :exam do
    association :subject
    name { "#{Faker::Educator.subject} Exam" }
    description { Faker::Lorem.paragraph }
    duration_minutes { [30, 45, 60, 90, 120].sample }
    retries { [1, 2, 3, 5].sample }
    pass_ratio { [60, 70, 75, 80].sample }
    number_of_questions_to_take { [5, 10, 15, 20].sample }

    trait :short do
      duration_minutes { 30 }
      number_of_questions_to_take { 5 }
    end

    trait :long do
      duration_minutes { 120 }
      number_of_questions_to_take { 20 }
    end

    trait :strict do
      retries { 1 }
      pass_ratio { 80 }
    end

    trait :lenient do
      retries { 5 }
      pass_ratio { 60 }
    end
  end

  sequence :unique_exam_name do |n|
    "#{Faker::Educator.subject} Exam #{n}"
  end
end
