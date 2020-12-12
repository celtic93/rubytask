Rails.application.routes.draw do
  devise_for :users

  resources :tasks do
    resources :comments, only: :create
  end

  root to: "tasks#index"
end
