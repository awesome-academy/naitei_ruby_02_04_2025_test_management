class CreateExamQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_questions do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :display_order

      t.timestamps
    end
    add_index :exam_questions, [:exam_id, :question_id], unique: true
  end
end
