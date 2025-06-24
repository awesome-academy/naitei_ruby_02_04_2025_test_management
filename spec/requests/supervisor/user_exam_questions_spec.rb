require 'rails_helper'

RSpec.describe "Supervisor::UserExamQuestions", type: :request do
  let(:supervisor) { create(:user, :supervisor) }
  let(:student) { create(:user) }
  let(:subject_instance) { create(:subject) }
  let(:exam) { create(:exam, subject: subject_instance) }
  let!(:essay_question) { create(:question, :essay, subject: subject_instance) }
  let!(:grading_pending_exam) { create(:user_exam, :grading_pending, user: student, exam: exam) }
  let!(:user_exam_question_to_grade) do
    create(:user_exam_question, user_exam: grading_pending_exam, question: essay_question, score: 0.0)
  end

  def sign_in user
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  context "when not signed in as a supervisor" do
    it "redirects non-supervisor users away" do
      patch grade_essay_supervisor_user_exam_question_path(locale: :vi, id: user_exam_question_to_grade.id), params: { user_exam_question: { score: 5.0 } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when signed in as a supervisor" do
    before { sign_in supervisor }

    describe "PATCH /supervisor/user_exam_questions/:id/grade_essay" do
      context "with a valid score" do
        it "updates the question's score and redirects with a notice" do
          new_score = 7.5
          patch grade_essay_supervisor_user_exam_question_path(locale: :vi, id: user_exam_question_to_grade.id),
                params: { user_exam_question: { score: new_score } }

          expect(response).to redirect_to(supervisor_user_exam_path(locale: :vi, id: grading_pending_exam.id))
          expect(flash[:notice]).to be_present

          user_exam_question_to_grade.reload
          expect(user_exam_question_to_grade.score).to eq(new_score)
        end
      end

      context "with an invalid score (e.g., non-numeric)" do
        it "does not update the score and redirects with an alert" do
          original_score = user_exam_question_to_grade.score
          patch grade_essay_supervisor_user_exam_question_path(user_exam_question_to_grade),
                params: { user_exam_question: { score: "invalid-score" } }

          expect(response).to redirect_to(supervisor_user_exam_path(grading_pending_exam))
          expect(flash[:alert]).to be_present

          user_exam_question_to_grade.reload
          expect(user_exam_question_to_grade.score).to eq(original_score)
        end
      end
    end
  end
end
