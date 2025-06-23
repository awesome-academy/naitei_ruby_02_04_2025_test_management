Rails.application.routes.draw do
  namespace :supervisor do
    get 'question_imports/new'
    get 'question_imports/create'
  end

  scope "(:locale)", locale: /en|vi/ do
    mount LetterOpenerWeb::Engine, at: "/letter_opener"

    root to: "subjects#index"

    resources :subjects, only: %i(index show)

    resources :exams, only: %i(index show) do
      resources :user_exams, only: %i(create)
    end

    resources :user_exams, only: %i(index show) do
      member do
        get :take_exam
        patch :submit_answers
      end
    end

    namespace :supervisor do
      resources :subjects do
        resources :exams
        resources :questions do
          get :export, on: :collection
        end
        resource :question_import, only: [:new, :create]
      end

      resources :questions, only: :index

      resources :user_exams, only: %i(index show) do
        member do
          patch :start_grading
          patch :finalize_grading
        end
      end

      resources :user_exam_questions, only: [] do
        patch :grade_essay, on: :member
      end

      resources :users, only: %i(index show) do
        member do
          patch :toggle_active
        end
      end
    end

    namespace :api, defaults: { format: :json } do
      namespace :v1 do
        resources :sessions, only: %i(create destroy)
        resources :users, only: %i(create)

        resources :subjects, only: %i(index show)

        namespace :supervisor do
          resources :subjects
        end
      end
    end
  end
end
