Rails.application.routes.draw do
  resources :events
  resources :applicants
  resources :attendances
  resources :rooms
  resources :room_assignments
  devise_for :users
  devise_scope :user do
    get "/users/sign_out", to: "devise/sessions#destroy"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/verify_attendance", to: "attendances#verify"
  post "/mark_attendance", to: "attendances#mark"

  resources :attendances do
    member do
      patch :toggle_status
    end
  end

  # Defines the root path route ("/")
  root "events#index"
end
