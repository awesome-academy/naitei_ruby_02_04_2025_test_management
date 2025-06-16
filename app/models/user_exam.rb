class UserExam < ApplicationRecord
  enum status: {
    pending: "pending",
    in_progress: "in_progress",
    completed: "completed",
    grading_pending: "grading_pending",
    pass: "pass",
    fail: "fail"
  }

  belongs_to :user
  belongs_to :exam

  has_many :user_exam_questions, dependent: :restrict_with_exception
  has_many :questions, through: :user_exam_questions
  has_many :answers, through: :user_exam_questions
  has_many :user_exam_answers, dependent: :restrict_with_exception

  validates :status, presence: true, inclusion: {in: statuses.keys}
  validates :attempt_number, presence: true,
numericality: {only_integer: true, greater_than_or_equal_to: Settings.user_exam.attempt_number.greater_than_or_equal_to}

  scope :latest, ->{order(created_at: :desc)}
  scope :search_by_subject_name, lambda {|query|
    joins(exam: :subject).where("subjects.name LIKE ?", "%#{query}%").distinct
  }
  scope :attempt, ->{order(attempt_number: :desc)}
  scope :search_by_user_or_subject, lambda {|query|
    return if query.blank?

    search_term = "%#{query.downcase}%"
    joins(:user, exam: :subject)
      .where("LOWER(users.name) LIKE :term OR LOWER(subjects.name) LIKE :term", term: search_term)
      .distinct
  }
  scope :search_by_user_name, lambda {|user_name_query|
    return if user_name_query.blank?

    joins(:user).where("LOWER(users.name) LIKE ?", "%#{user_name_query.downcase}%")
  }
  scope :get_exam, lambda {|exam_template|
    where(exam: exam_template)
  }

  def start_exam!
    return false unless pending?

    ActiveRecord::Base.transaction do
      self.status = "in_progress"
      self.started_at = Time.current
      save!
      num_questions = exam.number_of_questions_to_take
      available_questions = exam.subject.questions.order("RAND()").limit(num_questions)
      if available_questions.count < num_questions
        errors.add(:base, :not_enough_questions_in_subject)
        return false
      end
      available_questions.each_with_index do |question, index|
        user_exam_questions.create!(question:,
                                    display_order: index + 1)
      end
    end
    true
  rescue StandardError
    errors.add(:base, :error_on_start)
    false
  end

  def submit_answers! submitted_answers
    return false unless in_progress?

    ActiveRecord::Base.transaction do
      submitted_answers.each do |ueq_id, answer_data|
        user_exam_question = user_exam_questions.find_by(id: ueq_id)
        next unless user_exam_question

        if user_exam_question.question.essay?
          user_exam_question.update!(text_answer: answer_data[:text_answer])
        else
          user_exam_question.user_exam_answers.destroy_all
          ids_to_save = Array(answer_data[:answer_ids])
          ids_to_save.reject(&:blank?).each do |ans_id|
            user_exam_question.user_exam_answers.create!(answer_id: ans_id)
          end
        end
      end
      self.status = "completed"
      self.completed_at = Time.current
      save!
    end
    true
  rescue StandardError
    errors.add(:base, :error_on_submit)
    false
  end

  def initial_grade!
    return false unless completed?

    user_exam_questions.each do |ueq|
      question = ueq.question
      next if question.essay?

      score = 0.0
      if question.multiple_choice?
        correct_ids = question.answers.map do |ans|
          ans.id if ans.is_correct?
        end
        user_ids = ueq.user_exam_answers.pluck(:answer_id).sort
        score = 1.0 if correct_ids == user_ids && correct_ids.any?
      elsif question.single_choice?
        score = 1.0 if ueq.user_exam_answers.first&.answer&.is_correct?
      end
      ueq.update!(score:)
    end

    if questions.essay.exists?
      update!(status: "grading_pending")
    else
      finalize_grade!
    end
    true
  end

  def finalize_grade!
    return false unless grading_pending? || completed?

    total_score = user_exam_questions.sum(:score)
    max_possible_score = questions.count

    final_percentage = max_possible_score.positive? ? (total_score.to_f / max_possible_score * 100).round : 0
    self.score = final_percentage
    self.status = score >= exam.pass_ratio ? "pass" : "fail"
    save!
  end

  def ready_to_finalize?
    grading_pending? && user_exam_questions.joins(:question).where(
      questions: {question_type: :essay}, score: 0.0
    ).none?
  end
end
