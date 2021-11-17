Rails.application.routes.draw do
  namespace :users do
    resources :sessions, only: %i(index new create) do
      delete '/', to: 'sessions#destroy', on: :collection
    end
  end

  resources :users, only: %i(show)

  root to: "home#index"
end
