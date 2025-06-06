class SubjectsController < ApplicationController
  before_action :set_subject, except: %i(index)

  def index
    @pagy, @subjects = pagy Subject.latest.search(params[:query])
  end

  def show
    @questions = @subject.questions.latest
  end

  private

  def set_subject
    @subject = Subject.find_by(id: params[:id])
    return if @subject

    flash[:alert] = t(".not_found")
    redirect_to subjects_path
  end
end
