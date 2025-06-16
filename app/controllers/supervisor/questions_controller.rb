class Supervisor::QuestionsController < Supervisor::BaseController
  load_and_authorize_resource :subject
  load_and_authorize_resource :question, through: :subject, except: %i(index)

  def index
    @qts = Question.ransack(params[:qts])
    @questions = @qts.result.includes(:subject).latest
    @pagy, @questions = pagy @qts.result.includes(:subject).latest
    @subjects = Subject.order(:name).select(:id, :name)
  end

  def show; end

  def new
    @question.answers.build if @question.answers.empty?
  end

  def create
    if @question.save
      flash[:notice] = t(".success")
      redirect_to supervisor_subject_url(@subject)
    else
      flash.now[:alert] = t(".failure")
      if @question.answers.empty? && question_params[:answers_attributes].blank?
        @question.answers.build
      end
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if @question.answers.empty? && (@question.single_choice? || @question.multiple_choice?)
      @question.answers.build
    end
  end

  def update
    if @question.user_exam_questions.exists?
      original_params = question_params
      new_question_attrs = original_params.deep_dup

      if new_question_attrs[:answers_attributes].present?
        new_question_attrs[:answers_attributes].each_value do |ans_attrs|
          ans_attrs.delete(:id)
          ans_attrs.delete("id")
        end
      end

      @new_question = @subject.questions.build(new_question_attrs)

      if @new_question.save
        flash[:notice] = t(".question_in_use_created_new")
        redirect_to supervisor_subject_url(@subject)
      else
        flash.now[:alert] = t(".question_in_use_create_new_failed")
        @original_question_for_form = @question
        @question = @subject.questions.new(question_params)
        @question.errors.merge!(@new_question.errors)

        if @question.answers.empty? && question_params[:answers_attributes].present?
          question_params[:answers_attributes].each_value do |ans_attrs|
            unless ans_attrs[:_destroy] == "1"
              @question.answers.build(ans_attrs.except(:id,
                                                       :_destroy))
            end
          end
        end
        if @question.answers.empty? && (@question.single_choice? || @question.multiple_choice?)
          @question.answers.build
        end

        render :edit, status: :unprocessable_entity
      end
    elsif @question.update(question_params)
      flash[:notice] = t(".success")
      redirect_to supervisor_subject_url(@subject)
    else
      flash.now[:alert] = t(".failure")
      render :edit, status: :unprocessable_entity
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
    redirect_to supervisor_subject_url(@subject)
  end

  def export
    @questions = @subject.questions.includes(:answers).latest
    respond_to do |format|
      format.xlsx do
        response.headers["Content-Disposition"] =
          "attachment; filename=\"#{@subject.name.parameterize}_questions_#{Time.zone.now.strftime('%Y%m%d')}.xlsx\""
      end
    end
  end

  private

  def question_params
    params.require(:question).permit Question::QUESTION_PARAMS
  end
end
