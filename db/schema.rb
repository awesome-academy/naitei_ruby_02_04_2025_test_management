# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_05_23_055428) do
  create_table "answers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.text "content", null: false
    t.boolean "is_correct", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "enrolled_subjects", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_enrolled_subjects_on_subject_id"
    t.index ["user_id", "subject_id"], name: "index_enrolled_subjects_on_user_id_and_subject_id", unique: true
    t.index ["user_id"], name: "index_enrolled_subjects_on_user_id"
  end

  create_table "exam_questions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "question_id", null: false
    t.integer "display_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id", "question_id"], name: "index_exam_questions_on_exam_id_and_question_id", unique: true
    t.index ["exam_id"], name: "index_exam_questions_on_exam_id"
    t.index ["question_id"], name: "index_exam_questions_on_question_id"
  end

  create_table "exam_result_answers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "exam_question_id", null: false
    t.bigint "exam_result_id", null: false
    t.bigint "answer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_exam_result_answers_on_answer_id"
    t.index ["exam_question_id"], name: "index_exam_result_answers_on_exam_question_id"
    t.index ["exam_result_id"], name: "index_exam_result_answers_on_exam_result_id"
  end

  create_table "exam_results", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
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

  create_table "exams", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.string "name", null: false
    t.datetime "open_at"
    t.datetime "close_at"
    t.integer "duration_minutes"
    t.integer "retries", null: false
    t.integer "pass_ratio", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_exams_on_subject_id"
  end

  create_table "questions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.text "content", null: false
    t.string "question_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_questions_on_subject_id"
  end

  create_table "subjects", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_subjects_on_name", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "user", null: false
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false, null: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "enrolled_subjects", "subjects"
  add_foreign_key "enrolled_subjects", "users"
  add_foreign_key "exam_questions", "exams"
  add_foreign_key "exam_questions", "questions"
  add_foreign_key "exam_result_answers", "answers"
  add_foreign_key "exam_result_answers", "exam_questions"
  add_foreign_key "exam_result_answers", "exam_results"
  add_foreign_key "exam_results", "exams"
  add_foreign_key "exam_results", "users"
  add_foreign_key "exams", "subjects"
  add_foreign_key "questions", "subjects"
end
