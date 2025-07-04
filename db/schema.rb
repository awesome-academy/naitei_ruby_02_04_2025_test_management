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

ActiveRecord::Schema[7.0].define(version: 2025_07_01_091533) do
  create_table "answers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.text "content", null: false
    t.boolean "is_correct", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "exams", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.string "name", null: false
    t.integer "duration_minutes"
    t.integer "retries", null: false
    t.integer "pass_ratio", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "number_of_questions_to_take", default: 10, null: false
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

  create_table "user_exam_answers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_exam_question_id", null: false
    t.bigint "answer_id", null: false
    t.text "content_text"
    t.boolean "is_correct_at_submission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_user_exam_answers_on_answer_id"
    t.index ["user_exam_question_id"], name: "index_user_exam_answers_on_user_exam_question_id"
  end

  create_table "user_exam_questions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_exam_id", null: false
    t.bigint "question_id", null: false
    t.integer "display_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "text_answer"
    t.float "score", default: 0.0
    t.index ["question_id"], name: "index_user_exam_questions_on_question_id"
    t.index ["user_exam_id", "question_id"], name: "index_user_exam_questions_on_exam_and_question", unique: true
    t.index ["user_exam_id"], name: "index_user_exam_questions_on_user_exam_id"
  end

  create_table "user_exams", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exam_id", null: false
    t.string "status", default: "pending", null: false
    t.integer "score", default: 0
    t.integer "attempt_number", default: 1, null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_user_exams_on_exam_id"
    t.index ["user_id", "exam_id", "attempt_number"], name: "index_user_exams_on_user_exam_attempt", unique: true
    t.index ["user_id"], name: "index_user_exams_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "role", default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "active", default: true, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "exams", "subjects"
  add_foreign_key "questions", "subjects"
  add_foreign_key "user_exam_answers", "answers"
  add_foreign_key "user_exam_answers", "user_exam_questions"
  add_foreign_key "user_exam_questions", "questions"
  add_foreign_key "user_exam_questions", "user_exams"
  add_foreign_key "user_exams", "exams"
  add_foreign_key "user_exams", "users"
end
