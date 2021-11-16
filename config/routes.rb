Rails.application.routes.draw do
  namespace :users do
    resource :sessions, only: %i(new create destroy)
  end

  root to: "home#index"
end
