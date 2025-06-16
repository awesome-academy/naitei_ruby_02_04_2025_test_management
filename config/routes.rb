Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    mount LetterOpenerWeb::Engine, at: "/letter_opener"

    root to: "subjects#index"
    devise_for :users

    as :user do
      get "signup" => "devise/registrations#new"
      get "signin" => "devise/sessions#new"
      post "signin" => "devise/sessions#create"
      delete "signout" => "devise/sessions#destroy"
    end

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
        resources :questions
      end

      resources :questions, only: :index

      resources :user_exams, only: %i(index show) do
        member do
          post :grade
        end
      end

      resources :users, only: %i(index show) do
        member do
          patch :toggle_active
        end
      end
    end
  end
end
