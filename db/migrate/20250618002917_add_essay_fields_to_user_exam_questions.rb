class AddEssayFieldsToUserExamQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :user_exam_questions, :text_answer, :text
    add_column :user_exam_questions, :score, :float, default: 0.0
  end
end
