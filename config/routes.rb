Rails.application.routes.draw do
  root to: "scheduled_messages#index"

  match "/auth/:provider/callback" => "auth#oauth_callback", via: [:get]

  resources :diagnostics, only: [:index]
  resources :employees, only: [:new, :create, :index, :edit, :update, :destroy]
  resources :sent_scheduled_messages, only: [:index]
  resources :scheduled_messages, only: [:new, :create, :index, :edit, :update] do
    resources :test_messages, only: [:new, :create]
  end
end
