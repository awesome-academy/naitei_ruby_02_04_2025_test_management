class UserExamQuestion < ApplicationRecord
  belongs_to :user_exam
  belongs_to :question

  has_many :user_exam_answers, dependent: :destroy

  validates :question_id, uniqueness: { scope: :user_exam_id }
  validates :score, presence :true, numericality: { greater_than_or_equal_to: Settings.user_exam_question.score.greater_than_or_equal_to }

  scope :display, -> { order(:display_order) }
end
