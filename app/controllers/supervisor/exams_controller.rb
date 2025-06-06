class Supervisor::ExamsController < Supervisor::BaseController
  before_action :find_subject
  before_action :find_exam, except: %i(index new create)

  def index
    @exams = @subject.exams.latest
  end

  def show; end

  def new
    @exam = @subject.exams.build
  end

  def create
    @exam = @subject.exams.build(exam_params)

    if @exam.save
      flash[:notice] = t(".success")
      redirect_to supervisor_subject_exams_url(@subject)
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless @exam
      flash[:alert] = t(".not_found")
      redirect_to supervisor_subject_exams_url(@subject)
      return
    end
  end

  def update
    if @exam.user_exams.exists?
      update_used_exam
    else
      update_unused_exam
    end
  end

  def destroy
    if @exam.questions.exists?
      flash[:alert] = t(".has_questions")
    elsif @exam.destroy
      flash[:notice] = t(".success")
    else
      flash[:alert] = t(".failure")
    end
    redirect_to supervisor_subject_exams_url(@subject)
  end

  private

  def update_used_exam
    safe_params = exam_params.slice(*Exam::SAFE_TO_UPDATE_ATTRS)

    submitted_keys = exam_params.keys.map(&:to_sym)
    unsafe_keys_submitted = submitted_keys - Exam::SAFE_TO_UPDATE_ATTRS

    if @exam.update(safe_params)
      if unsafe_keys_submitted.any?
        flash[:notice] = t(".success_limited_update")
      else
        flash[:notice] = t(".success")
      end
      redirect_to edit_supervisor_subject_exam_path(@subject, @exam)
    else
      flash.now[:alert] = t(".failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def update_unused_exam
    if @exam.update(exam_params)
      flash[:notice] = t(".success")
      redirect_to edit_supervisor_subject_exam_path(@subject, @exam)
    else
      flash.now[:alert] = t(".failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def find_subject
    @subject = Subject.find_by(id: params[:subject_id])
    unless @subject
      flash[:alert] = t(".subject_not_found")
      redirect_to subjects_path
    end
  end

  def find_exam
    @exam = @subject.exams.find_by(id: params[:id])
    unless @exam
      flash[:alert] = t(".not_found")
      redirect_to supervisor_subject_exams_url(@subject)
    end
  end

  def exam_params
    params.require(:exam).permit Exam::EXAMS_PARAMS
  end
end
