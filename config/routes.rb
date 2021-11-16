Rails.application.routes.draw do
  namespace :users do
    resource :sessions, only: %i(new destroy)
  end

  root to: "home#index"
end
