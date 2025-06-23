require 'rails_helper'

RSpec.describe "Supervisor::UserExams", type: :request do
  let(:supervisor) { create(:user, :supervisor) }
  let(:student) { create(:user) }
  let(:subject_instance) { create(:subject) }
  let!(:exam) do
    exam = create(:exam, subject: subject_instance)
    create_list(:question, 5, :multiple_choice, subject: exam.subject)
    create_list(:question, 2, :essay, subject: exam.subject)
    exam
  end

  def sign_in user
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  context "when not signed in as a supervisor" do
    it "redirects non-supervisor users away" do
      get supervisor_user_exams_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when signed in as a supervisor" do
    before { sign_in supervisor }

    describe "GET /supervisor/user_exams" do
      let!(:user_exam) { create(:user_exam, :completed, user: student, exam: exam) }

      it "returns a successful response" do
        get supervisor_user_exams_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(student.name)
        expect(response.body).to include(exam.name)
      end
    end

    describe "GET /supervisor/user_exams/:id" do
      let!(:user_exam) { create(:user_exam, :passed, :with_questions, user: student, exam: exam) }

      it "returns a successful response" do
        get supervisor_user_exam_path(locale: :vi, id: user_exam.id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Kết quả bài làm")
        expect(response.body).to include(user_exam.questions.first.content)
      end
    end

    describe "PATCH /supervisor/user_exams/:id/start_grading" do
      let!(:completed_exam) do
        user_exam = create(:user_exam, status: "completed", user: student, exam: exam)
        user_exam.exam.subject.questions.each do |q|
          create(:user_exam_question, user_exam: user_exam, question: q)
        end
        user_exam
      end

      it "starts the initial grading and sets status to grading_pending" do
        patch start_grading_supervisor_user_exam_path(locale: :vi, id: completed_exam.id)

        expect(response).to redirect_to(supervisor_user_exam_path(locale: :vi, id: completed_exam))
        expect(flash[:notice]).to be_present

        completed_exam.reload
        expect(completed_exam.status).to eq("grading_pending")
      end
    end

    describe "PATCH /supervisor/user_exams/:id/finalize_grading" do
      context "when exam is ready to be finalized" do
        let!(:gradable_exam) do
          ue = create(:user_exam, status: "grading_pending", user: student, exam: exam)
          ue.exam.subject.questions.each do |q|
            create(:user_exam_question, user_exam: ue, question: q, score: 1.0)
          end
          ue
        end

        it "finalizes the grade and sets status to pass/fail" do
          patch finalize_grading_supervisor_user_exam_path(locale: :vi, id: gradable_exam)

          expect(response).to redirect_to(supervisor_user_exam_path(locale: :vi, id: gradable_exam))
          expect(flash[:notice]).to be_present

          gradable_exam.reload
          expect(gradable_exam.status).to match(/pass|fail/)
        end
      end

      context "when exam is not ready to be finalized" do
        let!(:not_ready_exam) do
          ue = create(:user_exam, status: "grading_pending", user: student, exam: exam)
          mc_question = ue.exam.subject.questions.find_by(question_type: "multiple_choice")
          create(:user_exam_question, user_exam: ue, question: mc_question, score: 1.0)
          essay_question = ue.exam.subject.questions.find_by(question_type: "essay")
          create(:user_exam_question, user_exam: ue, question: essay_question, score: 0.0)
          ue
        end

        it "does not finalize the grade and shows an alert" do
          patch finalize_grading_supervisor_user_exam_path(locale: :vi, id: not_ready_exam)
          expect(response).to redirect_to(supervisor_user_exam_path(locale: :vi, id: not_ready_exam))
          expect(flash[:alert]).to be_present

          not_ready_exam.reload
          expect(not_ready_exam.status).to eq("grading_pending")
        end
      end
    end
  end
end
