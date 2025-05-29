class SubjectsController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :authorize_supervisor!, except: %i(index show)
  before_action :set_subject, except: %i(index new create)

  def index
    @subjects = Subject.latest
  end

  def show; end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    if @subject.save
      flash[:notice] = t(".success")
      redirect_to subjects_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @subject.update(subject_params)
      flash[:notice] = t(".success")
      redirect_to @subject
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @subject.enrolled_users.exists?
      flash[:alert] = t(".has_enrolled_users")
    elsif @subject.questions.exists?
      flash[:alert] = t(".has_questions")
    elsif @subject.exams.exists?
      flash[:alert] = t(".has_exams")
    elsif @subject.destroy
      flash[:notice] = t(".success")
    else
      flash[:alert] = t(".failed")
    end
    redirect_to subjects_path
  end

  private

  def subject_params
    params.require(:subject).permit Subject::SUBJECT_ATTRS
  end

  def set_subject
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
