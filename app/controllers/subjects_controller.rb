class SubjectsController < ApplicationController
  load_and_authorize_resource except: %i(index)

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
end
