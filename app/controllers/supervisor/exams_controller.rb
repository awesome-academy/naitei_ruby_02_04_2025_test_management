class Supervisor::ExamsController < Supervisor::BaseController
  load_and_authorize_resource :subject
  load_and_authorize_resource :exam, through: :subject, singleton: true

  def index; end

  def show; end

  def new; end

  def create
    if @exam.save
      flash[:notice] = t(".success")
      redirect_to supervisor_subject_url(@subject)
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if all_user_exams_finished?
      update_unused_exam
    else
      update_used_exam
    end
    redirect_to supervisor_subject_path(@subject)
  end

  def destroy
    if @exam.user_exams.exists?
      flash[:alert] = t(".has_user_exams")
    elsif @exam.destroy
      flash[:notice] = t(".success")
    else
      flash[:alert] = t(".failure")
    end
    redirect_to supervisor_subject_path(@subject)
  end

  private

  def all_user_exams_finished?
    return true unless @exam.user_exams.exists?

    @exam.user_exams.all?{|ue| ue.pass? || ue.fail?}
  end

  def update_used_exam
    flash[:alert] = t(".exam_in_use")
  end

  def update_unused_exam
    if @exam.update(exam_params)
      flash[:notice] = t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def exam_params
    params.require(:exam).permit Exam::EXAMS_PARAMS
  end
end
