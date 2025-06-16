class Supervisor::QuestionImportsController < Supervisor::BaseController
  load_and_authorize_resource :subject

  def create
    file = params[:file]
    if file.nil?
      redirect_to supervisor_subject_path(@subject),
                  alert: "Vui lòng chọn một file Excel để import." and return
    end

    service = QuestionImportService.new(file:, subject: @subject)

    if service.call
      redirect_to supervisor_subject_path(@subject),
                  notice: "#{service.imported_count} câu hỏi đã được import thành công."
    else
      error_message = service.errors.join("; ")
      redirect_to supervisor_subject_path(@subject),
                  alert: "Import thất bại: #{error_message}"
    end
  end
end
