Rails.application.routes.draw do
  devise_for :users, path: 'auth'

  resources :users

  resources :tasks do
    resources :comments, shallow: true, only: %i(create update destroy)
  end

  get '/search', to: 'search_results#index'
  
  root to: "tasks#index"
end
