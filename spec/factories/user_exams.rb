FactoryBot.define do
  factory :user_exam do
    association :user
    association :exam
    status { 'pending' }
    score { 0 }
    attempt_number { 1 }

    trait :in_progress do
      status { 'in_progress' }
      started_at { 1.hour.ago }
    end

    trait :completed do
      status { 'completed' }
      started_at { 2.hours.ago }
      completed_at { 1.hour.ago }
      score { Faker::Number.between(from: 0, to: 100) }
    end

    trait :passed do
      completed
      score { Faker::Number.between(from: 70, to: 100) }
    end

    trait :failed do
      completed
      score { Faker::Number.between(from: 0, to: 60) }
    end

    trait :attempt do
      status { %w[in_progress completed].sample }
      started_at { Faker::Time.between(from: 1.week.ago, to: Time.current) }
    end

    trait :second_attempt do
      attempt_number { 2 }
    end

    trait :third_attempt do
      attempt_number { 3 }
    end

    trait :with_questions do
      after(:create) do |user_exam|
        questions = user_exam.exam.subject.questions.limit(user_exam.exam.number_of_questions_to_take)
        questions.each_with_index do |question, index|
          create(:user_exam_question,
                user_exam: user_exam,
                question: question,
                display_order: index + 1)
        end
      end
    end
  end
end
