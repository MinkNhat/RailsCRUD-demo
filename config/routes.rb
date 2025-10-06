Rails.application.routes.draw do
  # get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, path: "auth", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  namespace :api do
    namespace :v1 do
      # Public
      resources :categories, only: [ :index, :show ]
      resources :products, only: [ :index, :show ]

      # Private
      namespace :admin do
        resources :categories
        resources :products
        resources :users, only: [ :create ]
      end
    end
  end
end
