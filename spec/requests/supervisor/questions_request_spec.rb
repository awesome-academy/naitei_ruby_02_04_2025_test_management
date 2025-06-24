require 'rails_helper'

RSpec.describe "Supervisor::Questions", type: :request do
  let(:supervisor) { create(:user, :supervisor) }
  let(:subject_instance) { create(:subject) }
  let!(:question) { create(:question, :multiple_choice, subject: subject_instance) }

  let(:valid_question_params) do
    {
      question: attributes_for(:question,
        answers_attributes: {
          "0" => attributes_for(:answer, :correct),
          "1" => attributes_for(:answer)
        }
      )
    }
  end

  let(:invalid_question_params) do
    {
      question: attributes_for(:question, content: "",
        answers_attributes: {
          "0" => attributes_for(:answer, :correct)
        }
      )
    }
  end

  def sign_in user
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end

  context "when not signed in as a supervisor" do
    it "redirects non-supervisor users away" do
      get supervisor_questions_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when signed in as a supervisor" do
    before { sign_in supervisor }

    describe "GET /supervisor/subjects/:subject_id/questions" do
      it "returns a successful response" do
        get supervisor_questions_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(question.content)
      end
    end

    describe "GET /supervisor/subjects/:subject_id/questions/new" do
      it "returns a successful response" do
        get new_supervisor_subject_question_path(locale: :vi, subject_id: subject_instance.id)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /supervisor/subjects/:subject_id/questions" do
      context "with valid parameters" do
        it "creates a new question and its answers, then redirects" do
          expect {
            post supervisor_subject_questions_path(locale: :vi, subject_id: subject_instance.id), params: valid_question_params
          }.to change(Question, :count).by(1).and change(Answer, :count).by(2)

          expect(response).to redirect_to(supervisor_subject_path(locale: :vi, id: subject_instance.id))
          expect(flash[:notice]).to be_present
        end
      end

      context "with invalid parameters" do
        it "does not create a question and re-renders the new template" do
           expect {
            post supervisor_subject_questions_path(locale: :vi, subject_id: subject_instance.id), params: invalid_question_params
          }.not_to change(Question, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(flash.now[:alert]).to be_present
        end
      end
    end

    describe "PATCH /supervisor/subjects/:subject_id/questions/:id" do
      context "when question is NOT in use" do
        it "updates the question and redirects" do
          new_content = "This is the updated question content."
          patch supervisor_subject_question_path(locale: :vi, subject_id: subject_instance.id, id: question.id),
                params: { question: { content: new_content } }
          question.reload
          expect(question.content).to eq(new_content)
          expect(response).to redirect_to(supervisor_subject_path(locale: :vi, id: subject_instance.id))
          expect(flash[:notice]).to be_present
        end
      end
    end

    describe "DELETE /supervisor/subjects/:subject_id/questions/:id" do
      context "when question has answers" do
        it "does not destroy the question and shows an alert" do
          expect {
            delete supervisor_subject_question_path(locale: :vi, subject_id: subject_instance.id, id: question.id)
          }.not_to change(Question, :count)
          expect(response).to redirect_to(supervisor_subject_path(locale: :vi, id: subject_instance.id))
          expect(flash[:alert]).to be_present
        end
      end

      context "when question has no answers" do
        it "destroys the question and redirects" do
          question_without_answers = create(:question, :essay, subject: subject_instance)
          expect {
            delete supervisor_subject_question_path(locale: :vi, subject_id: subject_instance.id, id: question_without_answers.id)
          }.to change(Question, :count).by(-1)
          expect(response).to redirect_to(supervisor_subject_path(locale: :vi, id: subject_instance.id))
          expect(flash[:notice]).to be_present
        end
      end
    end
  end
end
