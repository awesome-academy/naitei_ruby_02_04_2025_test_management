# app/models/exam.rb
class Exam < ApplicationRecord
  EXAMS_PARAMS = [
    :name,
    :description,
    :number_of_questions_to_take,
    :duration_minutes,
    :retries,
    :pass_ratio
  ].freeze

  belongs_to :subject
  has_many :user_exams, dependent: :restrict_with_exception

  validates :name, presence: true, length: {
    maximum: ->(_record) { Settings.exam.name.max_length }
  }

  validates :duration_minutes, numericality: {
    only_integer: true,
    greater_than: ->(_record) { Settings.exam.duration.greater_than }
  }

  validates :retries, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: ->(_record) { Settings.exam.retries.greater_than_or_equal_to }
  }

  validates :pass_ratio, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: ->(_record) { Settings.exam.pass_ratio.greater_than_or_equal_to }
  }
end
