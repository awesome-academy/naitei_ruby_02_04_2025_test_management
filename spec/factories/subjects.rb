FactoryBot.define do
  factory :subject do
    name { Faker::Educator.subject }
    description { Faker::Lorem.paragraph(sentence_count: 3) }

    trait :with_questions do
      after(:create) do |subject|
        create_list(:question, 5, :multiple_choice, subject: subject)
      end
    end

    trait :with_exam do
      after(:create) do |subject|
        create(:exam, subject: subject)
      end
    end

    trait :with_questions_and_exam do
      with_questions
      with_exam
    end
  end

  sequence :unique_subject_name do |n|
    "#{Faker::Educator.subject} #{n}"
  end
end
