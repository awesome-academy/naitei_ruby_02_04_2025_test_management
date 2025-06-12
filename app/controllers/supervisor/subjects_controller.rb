class Supervisor::SubjectsController < Supervisor::BaseController
  before_action :find_subject_for_supervisor, except: %i(index new create)

  def index
    @pagy, @subjects = pagy Subject.latest.search(params[:query])
  end

  def show
    if @subject.exam.present?
      user_exams_scope = @subject.exam.user_exams.includes(:user).latest

      if params[:user_query].present?
        user_exams_scope = user_exams_scope.search_by_user_name(params[:user_query])
      end

      @pagy_user_exams, @user_exams_for_subject = pagy(
        user_exams_scope,
        page_param: :user_exams_page,
        params: params.except(:questions_page)
      )
      @search_user_query = params[:user_query]
    end

    @pagy_questions, @questions = pagy(
      @subject.questions.latest,
      page_param: :questions_page,
      params: params.except(:user_exams_page)
    )
    @exam = @subject.exam
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    if @subject.save
      flash[:notice] = t(".success")
      redirect_to supervisor_subjects_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @subject.update(subject_params)
      flash[:notice] = t(".success")
      redirect_to supervisor_subject_path(@subject)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @subject.questions.exists?
      flash[:alert] = t(".has_questions")
    elsif @subject.exam
      flash[:alert] = t(".has_exams")
    elsif @subject.destroy
      flash[:notice] = t(".success")
    else
      flash[:alert] = t(".failed")
    end
    redirect_to supervisor_subjects_path
  end

  private

  def subject_params
    params.require(:subject).permit Subject::SUBJECT_ATTRS
  end

  def find_subject_for_supervisor
    @subject = Subject.find_by(id: params[:id])
    return if @subject

    flash[:alert] = t(".not_found")
    redirect_to subjects_path
  end

  def authorize_supervisor!
    return if current_user.supervisor?

    flash[:alert] = t(".not_authorized")
    redirect_to root_path
  end
end
