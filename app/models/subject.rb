class Subject < ApplicationRecord
  has_many :questions, dependent: :restrict_with_exception
  has_many :exams, dependent: :restrict_with_exception

  has_many :enrolled_subjects, dependent: :restrict_with_exception
  has_many :enrolled_users, through: :enrolled_subjects, source: :user
end
