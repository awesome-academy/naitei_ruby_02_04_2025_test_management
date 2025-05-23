class Exam < ApplicationRecord
  belongs_to :subject

  has_many :exam_questions, dependent: :restrict_with_exception
  has_many :questions, through: :exam_questions

  has_many :exam_results, dependent: :restrict_with_exception
end
