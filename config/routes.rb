Rails.application.routes.draw do
  resources :inputs

  root to: 'visitors#index'
end
