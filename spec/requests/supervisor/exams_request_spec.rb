require 'rails_helper'

RSpec.describe "Supervisor::Exams", type: :request do
  let(:supervisor) { create(:user, :supervisor) }
  let(:subject_instance) { create(:subject) }

  def sign_in user
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  context "when signed in as a supervisor" do
    before { sign_in supervisor }

    describe "GET /supervisor/subjects/:subject_id/exam/new" do
      it "returns a successful response" do
        get new_supervisor_subject_exam_path(locale: :vi, subject_id: subject_instance.id)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /supervisor/subjects/:subject_id/exam/edit" do
      let!(:exam) { create(:exam, subject: subject_instance) }

      it "returns a successful response" do
        get edit_supervisor_subject_exam_path(locale: :vi, subject_id: subject_instance.id, id: exam.id)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /supervisor/subjects/:subject_id/exam" do
      let(:valid_attributes) { attributes_for(:exam) }
      let(:invalid_attributes) { attributes_for(:exam, name: "") }

      context "with valid parameters" do
        it "creates a new exam and redirects to the subject page" do
          expect {
            post supervisor_subject_exams_path(locale: :vi, subject_id: subject_instance.id), params: { exam: valid_attributes }
          }.to change(Exam, :count).by(1)

          expect(subject_instance.exam).to be_present
          expect(response).to redirect_to(supervisor_subject_path(locale: :vi, id: subject_instance.id))
          expect(flash[:notice]).to be_present
        end
      end

      context "with invalid parameters" do
        it "does not create an exam and re-renders the new template" do
          expect {
            post supervisor_subject_exams_path(locale: :vi, subject_id: subject_instance.id), params: { exam: invalid_attributes }
          }.not_to change(Exam, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(flash.now[:alert]).to be_present
        end
      end
    end

    describe "PATCH /supervisor/subjects/:subject_id/exam" do
      let!(:exam) { create(:exam, subject: subject_instance) }
      let(:new_attributes) { { name: "Updated Exam Name" } }

      context "when the exam has not been used" do
        it "updates the exam and redirects" do
          patch supervisor_subject_exam_path(locale: :vi, subject_id: subject_instance.id, id: exam.id), params: { exam: new_attributes }
          exam.reload
          expect(exam.name).to eq("Updated Exam Name")
          expect(response).to redirect_to(supervisor_subject_path(locale: :vi, id: subject_instance.id))
          expect(flash[:notice]).to be_present
        end
      end

      context "when all user exams are finished" do
        before do
          create(:user_exam, :passed, exam: exam)
        end

        it "updates the exam and redirects" do
          patch supervisor_subject_exam_path(locale: :vi, subject_id: subject_instance.id, id: exam.id), params: { exam: new_attributes }
          exam.reload
          expect(exam.name).to eq("Updated Exam Name")
          expect(flash[:notice]).to be_present
        end
      end

      context "when an exam attempt is in progress" do
        before do
          create(:user_exam, exam: exam)
        end

        it "does not update the exam and shows an alert" do
          patch supervisor_subject_exam_path(locale: :vi, subject_id: subject_instance.id, id: exam.id), params: { exam: new_attributes }
          exam.reload
          expect(exam.name).not_to eq("Updated Exam Name")
          expect(response).to redirect_to(supervisor_subject_path(locale: :vi, id: subject_instance.id))
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "DELETE /supervisor/subjects/:subject_id/exam" do
      let!(:exam) { create(:exam, subject: subject_instance) }

      context "when exam has no user attempts" do
        it "destroys the exam and redirects" do
          expect {
            delete supervisor_subject_exam_path(locale: :vi, subject_id: subject_instance.id, id: exam.id)
          }.to change(Exam, :count).by(-1)
          expect(response).to redirect_to(supervisor_subject_path(locale: :vi, id: subject_instance.id))
          expect(flash[:notice]).to be_present
        end
      end

      context "when exam has user attempts" do
        before { create(:user_exam, exam: exam) }

        it "does not destroy the exam and shows an alert" do
          expect {
            delete supervisor_subject_exam_path(locale: :vi, subject_id: subject_instance.id, id: exam.id)
          }.not_to change(Exam, :count)
          expect(response).to redirect_to(supervisor_subject_path(locale: :vi, id: subject_instance.id))
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
