Rails.application.routes.draw do
  root to: "employees#new"
  
  match '/auth/:provider/callback' => 'auth#oauth_callback', via: [:get]

  resources :employees, only: [:new, :create, :index, :edit, :update]
  resources :scheduled_messages, only: [:new, :create, :index, :edit, :update]
end
