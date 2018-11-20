Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :users, only: [:index, :show]
    resources :picks, only: [:show, :create]
    resources :slates, only: [:index, :show]
  end
end
