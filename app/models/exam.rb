class Exam < ApplicationRecord
  EXAMS_PARAMS = [
    :name,
    :open_at,
    :close_at,
    :duration_minutes,
    :retries,
    :pass_ratio,
    :description,
    :number_of_questions_to_take
  ].freeze

  SAFE_TO_UPDATE_ATTRS = [
    :name,
    :description,
    :open_at,
    :close_at
  ].freeze

  belongs_to :subject

  has_many :exam_questions, dependent: :restrict_with_exception
  has_many :questions, through: :exam_questions

  has_many :exam_results, dependent: :restrict_with_exception

  validates :name, presence: true, length: { maximum: Settings.exam.name.max_length }
  validates :open_at, presence: true
  validates :close_at, presence: true
  validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: Settings.exam.duration.greater_than }
  validates :retries, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: Settings.exam.retries.greater_than_or_equal_to }
  validates :pass_ratio, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: Settings.exam.pass_ratio.greater_than_or_equal_to }
  validate :validate_open_and_close_dates

  scope :latest, -> { order(open_at: :desc) }

  private

  def validate_open_and_close_dates
    if open_at.present? && close_at.present? && open_at >= close_at
      errors.add(:base, I18n.t("errors.messages.exam_open_close_dates"))
    end
  end
end
