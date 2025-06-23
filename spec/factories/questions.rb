FactoryBot.define do
  factory :question do
    association :subject
    content { Faker::Lorem.question }
    question_type { %w[multiple_choice single_choice essay].sample }

    trait :multiple_choice do
      question_type { 'multiple_choice' }

      before(:create) do |question|

        correct_option = build(:answer, :correct, question: nil)
        incorrect_options = build_list(:answer, 3, question: nil)

        question.answers = [correct_option] + incorrect_options
      end
    end

    trait :single_choice do
      question_type { 'single_choice' }

      after(:create) do |question|
        create_list(:answer, 3, question: question)
        create(:answer, :correct, question: question)
      end
    end

    trait :essay do
      question_type { 'essay' }
    end

    trait :with_answers do
      after(:create) do |question|
        create_list(:answer, 3, question: question)
        create(:answer, :correct, question: question)
      end
    end
  end
end
