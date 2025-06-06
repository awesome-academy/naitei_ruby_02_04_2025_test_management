class Answer < ApplicationRecord
  ANSWER_PARAMS = [
    :id,
    :content,
    :is_correct,
    :_destroy
  ].freeze

  belongs_to :question

  validates :content, presence: true
end
