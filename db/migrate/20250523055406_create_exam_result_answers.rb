class CreateExamResultAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_result_answers do |t|
      t.references :exam_question, null: false, foreign_key: true
      t.references :exam_result, null: false, foreign_key: true
      t.references :answer, foreign_key: true, null: false

      t.timestamps
    end
  end
end
