Rails.application.routes.draw do
  devise_for :users

  # resources :tasks, only: :index
  root to: "tasks#index"
end
