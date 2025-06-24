FactoryBot.define do
  factory :user_exam_question do
    association :user_exam
    association :question
    display_order { Faker::Number.between(from: 1, to: 20) }
    score { 0.0 }

    trait :answered do
      text_answer { Faker::Lorem.sentence }
      score { Faker::Number.decimal(l_digits: 1, r_digits: 1) }
    end

    trait :scored do
      score { Faker::Number.between(from: 0, to: 10) }
    end

    trait :with_multiple_answers do
      after(:create) do |user_exam_question|
        answers = user_exam_question.question.answers.sample(2)
        answers.each do |answer|
          create(:user_exam_answer,
                user_exam_question: user_exam_question,
                answer: answer)
        end
      end
    end
  end
end
