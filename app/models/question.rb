class Question < ApplicationRecord
  QUESTION_PARAMS = [
    :content,
    :question_type,
    {answers_attributes: Answer::ANSWER_PARAMS}
  ].freeze

  enum question_type: {
    single_choice: "single_choice",
    multiple_choice: "multiple_choice",
    essay: "essay"
  }

  belongs_to :subject
  has_many :answers, dependent: :restrict_with_exception
  has_many :user_exam_questions, dependent: :restrict_with_exception

  accepts_nested_attributes_for :answers, allow_destroy: true,
                                reject_if: :all_blank

  validates :content, presence: true
  validates :question_type, presence: true,
                            inclusion: {in: question_types.keys}
  validate :validate_answers_rules

  scope :latest, ->{order(created_at: :desc)}

  private

  def self.ransackable_attributes _auth_object = nil
    %w(content question_type created_at updated_at)
  end

  def self.ransackable_associations _auth_object = nil
    %w(subject)
  end

  def validate_answers_rules
    return if essay?

    active_answers = answers.reject(&:marked_for_destruction?)

    if question_type == "single_choice"
      if active_answers.size < 2
        errors.add(:answers, :single_choice_needs_min_answers)
      end
      correct_ones = active_answers.count(&:is_correct?)
      if active_answers.present? && correct_ones.zero?
        errors.add(:answers, :single_choice_needs_one_correct_answer)
      elsif correct_ones > 1
        errors.add(:answers, :single_choice_too_many_correct_answers)
      end
    elsif question_type == "multiple_choice"
      if active_answers.size < 2
        errors.add(:answers, :multiple_choice_needs_min_answers)
      end
      if active_answers.present? && active_answers.none?(&:is_correct?)
        errors.add(:answers, :multiple_choice_needs_one_correct_answer)
      end
    end
  end
end
