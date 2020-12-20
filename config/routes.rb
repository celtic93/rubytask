Rails.application.routes.draw do
  devise_for :users, path: 'auth'

  resources :users

  resources :tasks do
    resources :comments, shallow: true, only: %i(create update destroy)
  end

  resources :task_requests, only: :create do
    collection do
      patch 'accept'
      patch 'reject'
    end
  end

  get '/my_tasks', to: 'tasks#my_tasks'
  get '/my_works', to: 'task_requests#my_works'
  get '/search', to: 'search_results#index'
  
  root to: "tasks#index"
end
