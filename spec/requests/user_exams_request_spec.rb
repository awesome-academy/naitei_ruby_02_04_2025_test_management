require 'rails_helper'

RSpec.describe "UserExams", type: :request do
  let(:user) { create(:user) }
  let(:subject_instance) { create(:subject) }
  let!(:exam) do
    create(:exam, subject: subject_instance, retries: 3, number_of_questions_to_take: 5)
  end
  let!(:questions) { create_list(:question, 10, :multiple_choice, subject: subject_instance) }

  def sign_in user
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  context "when user is not signed in" do
    it "redirects to the sign-in page" do
      get user_exams_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when user is signed in" do
    before { sign_in user }

    describe "GET /user_exams" do
      let!(:user_exam) { create(:user_exam, :completed, user: user, exam: exam) }

      it "returns a successful response and lists user's exams" do
        get user_exams_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(exam.name)
      end
    end

    describe "POST /exams/:exam_id/user_exams" do
      context "when allowed to start" do
        it "creates a new user exam attempt and redirects to take_exam" do
          expect {
            post exam_user_exams_path(locale: :vi, exam_id: exam.id)
          }.to change(UserExam, :count).by(1)

          new_user_exam = UserExam.last
          expect(response).to redirect_to(take_exam_user_exam_path(locale: :vi, id: new_user_exam.id))
          expect(flash[:notice]).to be_present
        end
      end

      context "when max attempts are reached" do
        before do
          create_list(:user_exam, exam.retries, user: user, exam: exam)
        end

        it "does not create a new attempt and redirects with an alert" do
          expect {
            post exam_user_exams_path(locale: :vi, exam_id: exam.id)
          }.not_to change(UserExam, :count)

          expect(response).to redirect_to(exam_path(locale: :vi, id: exam.id))
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "GET /user_exams/:id/take_exam" do
      let(:in_progress_exam) { create(:user_exam, :in_progress, :with_questions, user: user, exam: exam) }

      context "with an in-progress exam" do
        it "shows the exam taking page" do
          get take_exam_user_exam_path(locale: :vi, id: in_progress_exam.id)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Đang tải thời gian")
        end
      end

      context "with an already completed exam" do
        let(:completed_exam) { create(:user_exam, :completed, user: user, exam: exam) }

        it "redirects to the result page with an alert" do
          get take_exam_user_exam_path(locale: :vi, id: completed_exam.id)
          expect(response).to redirect_to(user_exam_path(locale: :vi, id: completed_exam.id))
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "PATCH /user_exams/:id/submit_answers" do
      let(:in_progress_exam) { create(:user_exam, :in_progress, :with_questions, user: user, exam: exam) }

      it "submits the answers and redirects to the result page" do
        user_exam_question = in_progress_exam.user_exam_questions.first
        correct_answer_id = user_exam_question.question.answers.find_by(is_correct: true).id

        answers_params = {
          user_exam: {
            user_exam_questions: {
              "#{user_exam_question.id}" => { answer_ids: [correct_answer_id] }
            }
          }
        }

        patch submit_answers_user_exam_path(locale: :vi, id: in_progress_exam.id), params: answers_params

        expect(response).to redirect_to(user_exam_path(locale: :vi, id: in_progress_exam.id))
        expect(flash[:notice]).to be_present

        in_progress_exam.reload
        expect(in_progress_exam.status).to eq("completed")
      end
    end

    describe "GET /user_exams/:id" do
      let(:completed_exam) { create(:user_exam, :completed, :with_questions, user: user, exam: exam) }

      it "shows the exam result page" do
        get user_exam_path(locale: :vi, id: completed_exam.id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Kết quả bài làm của bạn")
        expect(response.body).to include(exam.name)
      end
    end
  end
end
