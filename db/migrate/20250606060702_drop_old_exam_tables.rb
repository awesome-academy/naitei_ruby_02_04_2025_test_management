# db/migrate/YYYYMMDDHHMMSS_drop_old_exam_tables.rb
class DropOldExamTables < ActiveRecord::Migration[7.0]
  def up
    drop_table :exam_result_answers, if_exists: true
    drop_table :exam_questions, if_exists: true
    drop_table :exam_results, if_exists: true
  end

  def down
    create_table :exam_results, if_not_exists: true, charset: "utf8mb4", collation: "utf8mb4_general_ci" do |t|
      t.bigint "exam_id", null: false
      t.bigint "user_id", null: false
      t.integer "score", default: 0
      t.string "status", default: "pending", null: false
      t.integer "attempt", default: 0
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["exam_id"], name: "index_exam_results_on_exam_id"
      t.index ["user_id"], name: "index_exam_results_on_user_id"
    end

    create_table :exam_questions, if_not_exists: true, charset: "utf8mb4", collation: "utf8mb4_general_ci" do |t|
      t.bigint "exam_id", null: false
      t.bigint "question_id", null: false
      t.integer "display_order"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["exam_id", "question_id"], name: "index_exam_questions_on_exam_id_and_question_id", unique: true
      t.index ["exam_id"], name: "index_exam_questions_on_exam_id"
      t.index ["question_id"], name: "index_exam_questions_on_question_id"
    end

    create_table :exam_result_answers, if_not_exists: true, charset: "utf8mb4", collation: "utf8mb4_general_ci" do |t|
      t.bigint "exam_question_id", null: false
      t.bigint "exam_result_id", null: false
      t.bigint "answer_id", null: true
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["answer_id"], name: "index_exam_result_answers_on_answer_id"
      t.index ["exam_question_id"], name: "index_exam_result_answers_on_exam_question_id"
      t.index ["exam_result_id"], name: "index_exam_result_answers_on_exam_result_id"
    end
  end
end
