class ExamResultAnswer < ApplicationRecord
  belongs_to :exam_question
  belongs_to :exam_result
  belongs_to :answer
end
