Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :users, only: [:index, :show, :create], param: :facebook_uuid do
      resources :picks, only: [:show, :create]
      resources :slates, only: [:index, :show]
    end
    resources :leagues, only: [:index]
    resources :teams, only: [:index, :show]
  end
  namespace :admin, defaults: { format: :json } do
    resources :teams, only: [:index, :show] do
      resources :slates, only: [:index, :show, :create, :update, :destroy] do
        resources :events, only: [:create, :show, :update]
      end
    end
  end
end
