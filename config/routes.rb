Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    mount LetterOpenerWeb::Engine, at: "/letter_opener"

    root to: "pages#home"
    get "/home", to: "pages#home"
    devise_for :users

    as :user do
      get "signup" => "devise/registrations#new"
      get "signin" => "devise/sessions#new"
      post "signin" => "devise/sessions#create"
      delete "signout" => "devise/sessions#destroy"
    end

    resources :subjects, only: %i(index show)

    namespace :supervisor do
      resources :subjects do
        resources :questions
      end
    end
  end
end
