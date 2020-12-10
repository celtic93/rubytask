Rails.application.routes.draw do
  devise_for :users

  resources :tasks, only: %i(index show new create)
  root to: "tasks#index"
end
