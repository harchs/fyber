Rails.application.routes.draw do
  root 'welcome#index'

  resources :offers, only: [:index]
end
