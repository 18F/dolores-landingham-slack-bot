Rails.application.routes.draw do
  root to: "employees#new"

  resources :employees, only: [:new, :create]
end
