class Supervisor::UserExamQuestionsController < Supervisor::BaseController
  def grade_essay
    @user_exam_question = UserExamQuestion.find(params[:id])
    authorize! :grade, @user_exam_question.user_exam

    score = params.require(:user_exam_question).permit(:score)[:score]
    if @user_exam_question.update(score:)
      redirect_to supervisor_user_exam_path(@user_exam_question.user_exam),
                  notice: "Đã cập nhật điểm cho câu hỏi."
    else
      redirect_to supervisor_user_exam_path(@user_exam_question.user_exam),
                  alert: "Không thể cập nhật điểm."
    end
  end
end
