Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :slates, only: [:index, :show]
    resources :users, only: [:index, :show, :create], param: :facebook_uuid do
      resources :picks, only: [:show, :create]
      resources :slates, only: [:index, :show]
    end
    resources :leagues, only: [:index]
    resources :teams, only: [:index]
  end
end
