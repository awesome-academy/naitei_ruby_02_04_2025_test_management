class UserExamsController < ApplicationController
  before_action :authenticate_user!
  load_resource :exam, only: :create
  load_resource :user_exam, through: :exam, only: :create
  load_and_authorize_resource except: %i(index create show)
  before_action :set_user_exam_details, only: :show

  def index
    @user_exams = current_user.user_exams
                              .includes(exam: :subject)
                              .latest
    if params[:query].present?
      @user_exams = @user_exams.search_by_subject_name(params[:query])
    end
    @search_query = params[:query]
  end

  def create
    attempt_count = current_user.user_exams.get_exam(@exam).count
    if attempt_count >= @exam.retries
      redirect_to @exam, alert: t(".max_attempts_reached") and return
    end

    @user_exam.user = current_user
    @user_exam.attempt_number = attempt_count + 1

    authorize! :create, @user_exam

    if @user_exam.start_exam!
      redirect_to take_exam_user_exam_path(@user_exam),
                  notice: t(".exam_started")
    else
      error_message = @user_exam.errors.full_messages.join(", ")
      redirect_to exam_path(@exam),
                  alert: t(".cannot_start_exam", error: error_message)
    end
  end

  def take_exam
    if @user_exam.completed?
      redirect_to user_exam_path(@user_exam), alert: t(".complete") and return
    end

    if @user_exam.pending?
      @user_exam.update(status: "in_progress",
                        started_at: Time.current)
    end

    duration = @user_exam.exam.duration_minutes
    if duration.present? && @user_exam.started_at.present?
      @end_time = @user_exam.started_at + duration.minutes
    end

    @user_exam_questions = @user_exam.user_exam_questions.includes(question: :answers)
  end

  def submit_answers
    if @user_exam.submit_answers!(answers_params)
      redirect_to user_exam_path(locale: I18n.locale, id: @user_exam.id),
                  notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :take_exam, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def answers_params
    ueq_params = params.require(:user_exam).fetch(:user_exam_questions, {})
    ueq_params.permit(ueq_params.keys.index_with do |_k|
                        [:text_answer, :answer_ids, {answer_ids: []}]
                      end).to_h
  end

  def set_user_exam_details
    @user_exam_with_details = UserExam.includes(
      user_exam_questions: [
        {question: :answers},
        :user_exam_answers
      ]
    ).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = t(".not_found")
    redirect_to supervisor_user_exams_path
  end
end
