class AdjustExams < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:exams, :description)
      add_column :exams, :description, :text
    end
    
    unless column_exists?(:exams, :number_of_questions_to_take)
      add_column :exams, :number_of_questions_to_take, :integer, null: false, default: 10
    end
  end
end
