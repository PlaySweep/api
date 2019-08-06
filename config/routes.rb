Rails.application.routes.draw do
  mount Resque::Server.new, at: '/resque'
  namespace :v1, defaults: { format: :json } do
    resources :users, only: [:index, :show, :create, :update], param: :facebook_uuid do
      scope module: :users do
        resources :picks, only: [:index, :show, :create, :update]
        resources :slates, only: [:index, :show]
        resources :entries, only: [:create]
        resources :roles, only: [:create]
      end
    end
    resources :statuses, only: [:index, :show], param: :facebook_uuid
    resources :slates, only: [:index, :show, :update]
    resources :entries, only: [:create]
    resources :orders, only: [:create]
    resources :teams, only: [:index]
  end
  
  namespace :admin, defaults: { format: :json } do
    resources :leagues, only: [:index]
    resources :teams, only: [:index, :show] do
      resources :slates, only: [:index, :show, :create, :update, :destroy] do
        resources :events, only: [:create, :show, :update, :destroy]
      end
      resources :products, only: [:index, :show, :create]
    end
  end
end
