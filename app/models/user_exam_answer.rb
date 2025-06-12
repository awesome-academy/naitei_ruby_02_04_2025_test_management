class UserExamAnswer < ApplicationRecord
  belongs_to :user_exam_question
  belongs_to :answer

  has_one :user_exam, through: :user_exam_question
  has_one :question, through: :user_exam_question
end
