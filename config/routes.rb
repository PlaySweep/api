require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  namespace :v1, defaults: { format: :json } do
    
    get 'users/show', to: 'users#fetch_by_slug'
    get 'users/by_referral_code', to: 'users#by_referral_code'
    get 'users/:id/reset', to: 'users#reset'
    resources :users, only: [:index, :show, :create, :update] do
      scope module: :users do
        member do
          get "status", to: "statuses#status"
          get "slate_status", to: "statuses#slate_status"
        end
        resources :picks, only: [:index, :show, :create, :update]
        resources :slates, only: [:index, :show]
        resources :roles, only: [:create]
        member do
          get "roles/change_teams"
        end
      end
    end

    scope :facebook do
      scope module: :facebook do
        resources :sessions, only: :show, param: :facebook_uuid
      end
    end

    resources :slates, only: [:index, :show, :update]
    resources :orders, only: [:create]
    resources :teams, only: [:index]
  end
  
  namespace :admin, defaults: { format: :json } do
    resources :leagues, only: [:index]
    resources :teams, only: [:index, :show]
    resources :slates, only: [:index, :show, :create, :update, :destroy] do
      resources :events, only: [:create, :show, :update, :destroy]
    end
    resources :products, only: [:index, :show, :create]
  end
end
