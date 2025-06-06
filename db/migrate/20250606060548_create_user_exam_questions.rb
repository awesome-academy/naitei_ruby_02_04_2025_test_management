class CreateUserExamQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_exam_questions do |t|
      t.references :user_exam, null: false, foreign_key: true, type: :bigint
      t.references :question, null: false, foreign_key: true, type: :bigint
      t.integer :display_order

      t.timestamps
    end

    add_index :user_exam_questions, [:user_exam_id, :question_id], unique: true, name: 'index_user_exam_questions_on_exam_and_question'
  end
end
