require 'rails_helper'

RSpec.describe "Supervisor::Subjects", type: :request do
  let(:supervisor) { create(:user, :supervisor) }
  let(:regular_user) { create(:user) }
  let!(:subject) { create(:subject) }

  def sign_in user
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  context "when not signed in" do
    it "redirects to the sign in page" do
      get supervisor_subjects_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when signed in as a supervisor" do
    before { sign_in supervisor }

    describe "GET /supervisor/subjects" do
      it "returns a successful response" do
        get supervisor_subjects_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(subject.name)
      end
    end

    describe "GET /supervisor/subjects/:id" do
      let!(:subject_with_exam) { create(:subject, :with_questions_and_exam) }
      let!(:user_exam) { create(:user_exam, exam: subject_with_exam.exam, user: regular_user) }

      it "returns a successful response" do
        get supervisor_subject_path(subject_with_exam)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(subject_with_exam.name)
        expect(response.body).to include("Các lượt làm bài của học viên")
        expect(response.body).to include(regular_user.name)
        expect(response.body).to include("Danh sách câu hỏi")
      end

      it "filters user exams by user name" do
        another_user = create(:user, name: "Another Person")
        create(:user_exam, exam: subject_with_exam.exam, user: another_user)

        get supervisor_subject_path(subject_with_exam), params: { user_query: "Another Person" }

        expect(response.body).to include("Another Person")
        expect(response.body).not_to include(regular_user.name)
      end
    end

    describe "GET /supervisor/subjects/new" do
      it "returns a successful response" do
        get new_supervisor_subject_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /supervisor/subjects/:id/edit" do
      it "returns a successful response" do
        get edit_supervisor_subject_path(subject)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /supervisor/subjects" do
      let(:valid_attributes) { { name: "New Subject", description: "A valid description." } }
      let(:invalid_attributes) { { name: "", description: "Invalid subject." } }

      context "with valid parameters" do
        it "creates a new subject and redirects" do
          expect {
            post supervisor_subjects_path, params: { subject: valid_attributes }
          }.to change(Subject, :count).by(1)
          expect(response).to redirect_to(supervisor_subjects_path)
          expect(flash[:notice]).to be_present
        end
      end

      context "with invalid parameters" do
        it "does not create a new subject and re-renders the new template" do
          expect {
            post supervisor_subjects_path, params: { subject: invalid_attributes }
          }.to change(Subject, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH /supervisor/subjects/:id" do
      let(:new_attributes) { { name: "Updated Subject Name" } }

      it "updates the requested subject and redirects" do
        patch supervisor_subject_path(subject), params: { subject: new_attributes }
        subject.reload
        expect(subject.name).to eq("Updated Subject Name")
        expect(response).to redirect_to(supervisor_subject_path(subject))
        expect(flash[:notice]).to be_present
      end
    end

    describe "DELETE /supervisor/subjects/:id" do
      context "when subject can be destroyed" do
        it "destroys the requested subject and redirects" do
          subject_to_delete = create(:subject)
          expect {
            delete supervisor_subject_path(subject_to_delete)
          }.to change(Subject, :count).by(-1)
          expect(response).to redirect_to(supervisor_subjects_path)
          expect(flash[:notice]).to be_present
        end
      end

      context "when subject has associated questions" do
        it "does not destroy the subject and shows an alert" do
          subject_with_question = create(:subject, :with_questions)
          expect {
            delete supervisor_subject_path(subject_with_question)
          }.to change(Subject, :count).by(0)
          expect(response).to redirect_to(supervisor_subjects_path)
          expect(flash[:alert]).to include("Không thể xóa môn học này vì có các câu hỏi liên quan.")
        end
      end

      context "when subject has an associated exam" do
        it "does not destroy the subject and shows an alert" do
          subject_with_exam = create(:subject, :with_exam)
          expect {
            delete supervisor_subject_path(subject_with_exam)
          }.to change(Subject, :count).by(0)
          expect(response).to redirect_to(supervisor_subjects_path)
          expect(flash[:alert]).to include("Không thể xóa môn học này vì có các bài kiểm tra liên quan.")
        end
      end
    end
  end
end
