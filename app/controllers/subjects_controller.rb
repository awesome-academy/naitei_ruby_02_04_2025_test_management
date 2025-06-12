class SubjectsController < ApplicationController
  before_action :set_subject, except: %i(index)

  def index
    @pagy, @subjects = pagy Subject.latest.search(params[:query])
  end

  def show
    @questions = @subject.questions.latest
    @exam = @subject.exam
    @user_attempts = UserExam.none

    if user_signed_in? && @exam.present?
      @user_attempts = current_user.user_exams
                                   .get_exam(@exam)
                                   .attempt
    end
  end

  private

  def set_subject
    @subject = Subject.find_by(id: params[:id])
    return if @subject

    flash[:alert] = t(".not_found")
    redirect_to subjects_path
  end
end
