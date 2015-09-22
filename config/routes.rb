Rails.application.routes.draw do
  root to: "employees#new"

  resources :employees, only: [:new, :create, :index, :edit, :update]
  resources :scheduled_messages, only: [:new, :create, :index, :edit, :update]
end
