class UserExam < ApplicationRecord
  enum status: {
    pending: "pending",
    in_progress: "in_progress",
    completed: "completed",
    pass: "pass",
    fail: "fail"
  }

  belongs_to :user
  belongs_to :exam

  has_many :user_exam_questions, dependent: :restrict_with_exception
  has_many :questions, through: :user_exam_questions
  has_many :answers, through: :user_exam_questions
  has_many :user_exam_answers, dependent: :restrict_with_exception

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :attempt_number, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: Settings.user_exam.attempt_number.greater_than_or_equal_to }

  scope :latest, -> { order(created_at: :desc) }
  scope :search_by_subject_name, ->(query) {
    joins(exam: :subject).where("subjects.name LIKE ?", "%#{query}%").distinct
  }
  scope :attempt, -> { order(attempt_number: :desc) }
  scope :search_by_user_or_subject, ->(query) {
    return if query.blank?
    search_term = "%#{query.downcase}%"
    joins(:user, exam: :subject)
      .where("LOWER(users.name) LIKE :term OR LOWER(subjects.name) LIKE :term", term: search_term)
      .distinct
  }
  scope :search_by_user_name, ->(user_name_query) {
    return if user_name_query.blank?
    joins(:user).where("LOWER(users.name) LIKE ?", "%#{user_name_query.downcase}%")
  }
  scope :get_exam, -> (exam_template) {
    where(exam: exam_template)
  }

  def start_exam!
    return false unless pending?
    ActiveRecord::Base.transaction do
      self.status = "in_progress"
      self.started_at = Time.current
      save!
      num_questions = self.exam.number_of_questions_to_take
      available_questions = self.exam.subject.questions.order("RAND()").limit(num_questions)
      if available_questions.count < num_questions
        errors.add(:base, :not_enough_questions_in_subject)
        return false
      end
      available_questions.each_with_index do |question, index|
        self.user_exam_questions.create!(question: question, display_order: index + 1)
      end
    end
    true
  rescue
    errors.add(:base, :error_on_start)
    false
  end

  def submit_answers!(submitted_answers)
    return false unless in_progress?
    ActiveRecord::Base.transaction do
      submitted_answers.each do |ueq_id, answer_data|
        user_exam_question = self.user_exam_questions.find_by(id: ueq_id)
        next unless user_exam_question
        user_exam_question.user_exam_answers.destroy_all
        ids_to_save = Array(answer_data[:answer_ids])
        ids_to_save.reject(&:blank?).each do |ans_id|
          user_exam_question.user_exam_answers.create!(answer_id: ans_id)
        end
      end
      self.status = "completed"
      self.completed_at = Time.current
      save!
    end
    true
  rescue => e
    errors.add(:base, :error_on_submit)
    false
  end

  def grade_exam!
    return false unless completed?
    correct_count = 0
    self.user_exam_questions.each do |ueq|
      question = ueq.question
      if question.multiple_choice?
        correct_ids = question.answers.where(is_correct: true).pluck(:id).sort
        user_ids = ueq.user_exam_answers.pluck(:answer_id).sort
        correct_count += 1 if correct_ids == user_ids
      elsif question.single_choice?
        correct_count += 1 if ueq.user_exam_answers.first&.answer&.is_correct?
      end
    end
    total_questions = self.questions.count
    self.score = total_questions > 0 ? (correct_count.to_f / total_questions * 100).round : 0
    self.status = (self.score >= self.exam.pass_ratio) ? "pass" : "fail"
    save!
  end
end
