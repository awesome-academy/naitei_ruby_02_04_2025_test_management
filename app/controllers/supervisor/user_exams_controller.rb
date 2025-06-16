class Supervisor::UserExamsController < Supervisor::BaseController
  load_and_authorize_resource only: %i(start_grading finalize_grading show)
  before_action :set_user_exam_details, only: %i(show)

  def index
    user_exams_scope = UserExam.includes(:user, exam: :subject).latest

    if params[:query].present?
      user_exams_scope = user_exams_scope.search_by_user_or_subject(params[:query])
    end

    @pagy, @user_exams = pagy(user_exams_scope)
    @search_query = params[:query]
  end

  def show; end

  def start_grading
    if @user_exam.initial_grade!
      redirect_to supervisor_user_exam_path(@user_exam),
                  notice: t(".success_autograded")
    else
      redirect_to supervisor_user_exam_path(@user_exam), alert: t(".fail")
    end
  end

  def finalize_grading
    if @user_exam.ready_to_finalize?
      @user_exam.finalize_grade!
      redirect_to supervisor_user_exam_path(@user_exam),
                  notice: t(".success_finalized")
    else
      redirect_to supervisor_user_exam_path(@user_exam),
                  alert: t(".not_ready_to_finalize")
    end
  end

  private

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
