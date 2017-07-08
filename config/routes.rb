Rails.application.routes.draw do
  get 'destroy/ElectionsController'

  resources :elections
end
