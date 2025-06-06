class CreateUserExamAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_exam_answers do |t|
      t.references :user_exam_question, null: false, foreign_key: true, type: :bigint
      t.references :answer, foreign_key: true, type: :bigint, null: false
      t.text :content_text
      t.boolean :is_correct_at_submission, null: true

      t.timestamps
    end
  end
end
