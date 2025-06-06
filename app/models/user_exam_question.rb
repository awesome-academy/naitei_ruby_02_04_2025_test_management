class UserExamQuestion < ApplicationRecord
  belongs_to :user_exam
  belongs_to :question

  has_many :user_exam_answers, dependent: :destroy

  validates :question_id, uniqueness: { scope: :user_exam_id }

  scope :display, -> { order(:display_order) }
end
