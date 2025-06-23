require 'rails_helper'

RSpec.describe "Subjects", type: :request do
  let(:user) { create(:user) }
  let(:subject_with_exam) { create(:subject, :with_questions_and_exam) }

  describe "GET /subjects" do
    context 'without search query' do
      let!(:subjects) { create_list(:subject, 3) }

      it 'returns a successful response and displays all subjects' do
        get subjects_path

        expect(response).to have_http_status(:ok)

        subjects.each do |subject|
          expect(response.body).to include(subject.name)
        end
      end
    end

    context 'with search query' do
      let!(:math_subject) { create(:subject, name: 'Mathematics') }
      let!(:physics_subject) { create(:subject, name: 'Physics') }

      it 'returns filtered subjects in the response body' do
        get subjects_path, params: { query: 'Math' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(math_subject.name)
        expect(response.body).not_to include(physics_subject.name)
      end
    end
  end

  describe 'GET /subjects/:id' do
    context 'when user is not signed in' do
      it 'returns a successful response and shows subject details' do
        get subject_path(locale: :vi, id: subject_with_exam)

        expect(response).to have_http_status(:ok)

        expect(response.body).to include(subject_with_exam.name)
      end
    end

    context 'when user is signed in' do
      before { sign_in user }

      context 'when subject has no exam' do
        let(:subject_without_exam) { create(:subject, :with_questions) }

        it 'shows the subject but no exam attempts section' do
          get subject_path(subject_without_exam)

          expect(response).to have_http_status(:ok)
          expect(response.body).to include(subject_without_exam.name)
        end
      end

      context 'when subject has exam' do
        let!(:user_exam) { create(:user_exam, user: user, exam: subject_with_exam.exam) }

        it "shows the user's exam attempts" do
          get subject_path(subject_with_exam)

          expect(response).to have_http_status(:ok)
          expect(response.body).to include(subject_with_exam.exam.name)
        end
      end

      context 'when user has done the exam' do
        let!(:user_exam) { create(:user_exam, :completed, user: user, exam: subject_with_exam.exam) }
        it 'shows the user exam attempts' do
          get subject_path(subject_with_exam)

          expect(response).to have_http_status(:ok)
          expect(response.body).to include(subject_with_exam.exam.name)
          expect(response.body).to include("Lần làm thứ 1")
        end
      end
    end
  end

  def sign_in user
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end
end
