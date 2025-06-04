class DropEnrolledSubjects < ActiveRecord::Migration[7.0]
  def up
    drop_table :enrolled_subjects
  end

  def down
    create_table "enrolled_subjects", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "subject_id", null: false
      t.boolean "is_pass", default: false, null: false
    end
    add_foreign_key :enrolled_subjects, :users, column: :user_id
    add_foreign_key :enrolled_subjects, :subjects, column: :subject_id

    add_index :enrolled_subjects, :subject_id, name: "index_enrolled_subjects_on_subject_id"
    add_index :enrolled_subjects, [:user_id, :subject_id], name: "index_enrolled_subjects_on_user_id_and_subject_id", unique: true
    add_index :enrolled_subjects, :user_id, name: "index_enrolled_subjects_on_user_id"
  end
end
