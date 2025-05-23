class ExamQuestion < ApplicationRecord
  belongs_to :exam
  belongs_to :question

  has_many :exam_results_answers, dependent: :restrict_with_exception
end
