Rails.application.routes.draw do
  root 'elections#index'
  resources :elections, only: %w(create show new destroy), shallow: true do
    resources :votes do
      resources :ballots
      resources :results, only: %w(create show destroy)
    end
  end
end