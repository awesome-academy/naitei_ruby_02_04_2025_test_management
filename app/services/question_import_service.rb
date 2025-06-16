# app/services/question_import_service.rb

class QuestionImportService
  attr_reader :errors, :imported_count

  def initialize file:, subject:
    @file = file
    @subject = subject
    @errors = []
    @imported_count = 0
  end

  def call
    ActiveRecord::Base.transaction do
      questions_data = build_questions_from_file
      if questions_data.empty?
        raise ActiveRecord::Rollback,
              "File rỗng hoặc không có dữ liệu."
      end

      @imported_count = questions_data.count

      questions_to_import = questions_data.map do |data|
        Question.new(data[:question_attributes].merge(answers_attributes: data[:answers_attributes]))
      end

      question_import_result = Question.import(questions_to_import,
                                               validate: true)

      if question_import_result.failed_instances.any?
        handle_failed_instances(question_import_result.failed_instances,
                                "Question")
        raise ActiveRecord::Rollback
      end

      contents = questions_to_import.map(&:content)
      imported_questions_map = Question.where(content: contents,
                                              subject_id: @subject.id).index_by(&:content)

      answers_to_import = build_answers_for_imported_questions(
        questions_to_import, imported_questions_map
      )

      if answers_to_import.any?
        answer_result = Answer.import(answers_to_import, validate: true)
        if answer_result.failed_instances.any?
          handle_failed_instances(answer_result.failed_instances, "Answer")
          raise ActiveRecord::Rollback
        end
      end
    end
    @errors.empty?
  rescue ActiveRecord::Rollback
    if @errors.empty?
      @errors << "Dữ liệu không hợp lệ, quá trình import đã được hủy bỏ."
    end
    false
  rescue StandardError => e
    @errors << "Lỗi hệ thống không xác định: #{e.message}"
    false
  end

  private

  def build_questions_from_file
    spreadsheet = Roo::Spreadsheet.open(@file.path,
                                        extension: File.extname(@file.path).delete("."))
    header = spreadsheet.row(1).map(&:strip)
    questions_data = Hash.new do |h, k|
      h[k] = {question_attributes: {}, answers_attributes: []}
    end

    (2..spreadsheet.last_row).each do |i|
      row_values = spreadsheet.row(i)
      next if row_values.blank?

      row = Hash[header.zip(row_values)]
      question_content = row["question_content"]&.strip
      next if question_content.blank?

      if questions_data[question_content][:question_attributes].empty?
        questions_data[question_content][:question_attributes] = {
          content: question_content,
          question_type: row["question_type"]&.strip,
          subject: @subject
        }
      end

      next if row["answer_content"].blank?

      questions_data[question_content][:answers_attributes] << {
        content: row["answer_content"],
        is_correct: row["is_correct"].to_s.downcase == "true"
      }
    end
    questions_data.values
  end

  def build_answers_for_imported_questions questions_in_memory,
    imported_questions_map
    answers_to_import = []
    questions_in_memory.each do |question_object|
      saved_question = imported_questions_map[question_object.content]
      next unless saved_question

      question_object.answers.each do |answer_object|
        answer_object.question_id = saved_question.id
        answers_to_import << answer_object
      end
    end
    answers_to_import
  end

  def handle_failed_instances failed_instances, model_name
    failed_instances.each do |instance|
      error_key = instance.try(:content) || "không xác định"
      error_key = error_key.truncate(50)
      @errors << "Lỗi ở #{model_name} '#{error_key}...': #{instance.errors.full_messages.join(', ')}"
    end
  end
end
