class CreateUserExams < ActiveRecord::Migration[7.0]
  def change
    create_table :user_exams do |t|
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.references :exam, null: false, foreign_key: true, type: :bigint
      t.string :status, null: false, default: "pending"
      t.integer :score, default: 0
      t.integer :attempt_number, null: false, default: 1
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :user_exams, [:user_id, :exam_id, :attempt_number], unique: true, name: 'index_user_exams_on_user_exam_attempt'
  end
end
