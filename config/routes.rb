Rails.application.routes.draw do
  devise_for :users

  resources :tasks do
    resources :comments, except: %i(index new)
  end

  root to: "tasks#index"
end
