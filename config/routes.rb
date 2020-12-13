Rails.application.routes.draw do
  devise_for :users

  resources :tasks do
    resources :comments, shallow: true, only: %i(create update destroy)
  end

  root to: "tasks#index"
end
