class Supervisor::QuestionsController < Supervisor::BaseController
  before_action :find_subject
  before_action :find_question, except: %i(index new create)

  def index
    @questions = @subject.questions.latest
  end

  def show; end

  def new
    @question = @subject.questions.build
    @question.answers.build if @question.answers.empty?
  end

  def create
    @question = @subject.questions.build(question_params)

    if @question.save
      flash[:notice] = t(".success")
      redirect_to subject_questions_url(@subject)
    else
      flash.now[:alert] = t(".failure")
      @question.answers.build if @question.answers.empty? && question_params[:answers_attributes].blank?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @question.answers.build if @question.answers.empty? && (@question.single_choice? || @question.multiple_choice?)
  end

  def update
    if @question.user_exam_questions.exists?
      @new_question = @subject.questions.build(question_params)

      if @new_question.save
        flash[:notice] = t(".question_in_use_created_new")
        redirect_to subject_questions_url(@subject)
      else
        flash.now[:alert] = t(".question_in_use_create_new_failed")
        @original_question_for_form = @question
        @question = @subject.questions.new(question_params)
        @question.errors.merge!(@new_question.errors)

        if @question.answers.empty? && question_params[:answers_attributes].present?
          question_params[:answers_attributes].each_value do |ans_attrs|
            @question.answers.build(ans_attrs.except(:id, :_destroy)) unless ans_attrs[:_destroy] == '1'
          end
        end
        @question.answers.build if @question.answers.empty? && (@question.single_choice? || @question.multiple_choice?)

        render :edit, status: :unprocessable_entity
      end
    else
      if @question.update(question_params)
        flash[:notice] = t(".success")
        redirect_to subject_questions_url(@subject)
      else
        flash.now[:alert] = t(".failure")
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @question.answers.exists?
      flash[:alert] = t(".has_answers")
    elsif @question.destroy
      flash[:notice] = t(".success")
    else
      flash[:alert] = t(".failure")
    end
    redirect_to subject_questions_url(@subject)
  end

  private

  def find_subject
    @subject = Subject.find_by(id: params[:subject_id])
    return if @subject

    flash[:alert] = t(".subject_not_found")
    redirect_to subjects_path
  end

  def find_question
    @question = @subject.questions.find_by(id: params[:id])
    unless @question
      flash[:alert] = t(".not_found")
      redirect_to subject_questions_path(@subject)
    end
  end

  def question_params
    params.require(:question).permit Question::QUESTION_PARAMS
  end
end
