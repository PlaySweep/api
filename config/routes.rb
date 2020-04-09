require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  namespace :v1, defaults: { format: :json } do
    get 'users/show', to: 'users#fetch_by_slug'
    resources :users, only: [:index, :show, :create, :update] do
      scope module: :users do
        member do
          get "roles/change_teams"
        end
        resources :addresses, only: [:show, :create, :update]
        resources :phone_numbers, only: [:show, :create, :update]
        resources :picks, only: [:index, :show, :create, :update]
        resources :choices, only: [:index, :show, :create, :update]
        resources :roles, only: [:create]
        resources :slates, only: [:index, :show]
        resources :quizzes, only: [:index, :show]
        resources :cards, only: [:index, :create, :update]
        resources :user_elements, only: [:index, :update]
      end
    end

    scope :facebook do
      scope module: :facebook do
        resources :sessions, only: :show, param: :facebook_uuid
      end
    end

    resources :achievements, only: [:index]
    resources :contests, :slates, :quizzes, only: [:index, :show, :update]
    resources :orders, only: [:index, :create]
    resources :prizes, only: [:show]
    resources :teams, only: [:index]
    resources :questions, only: [:show]
    resources :question_sessions, only: [:create, :update]
  end
  
  namespace :admin, defaults: { format: :json } do
    resources :leagues, only: [:index]
    resources :teams, only: [:index, :show]
    resources :slates, only: [:index, :show, :create, :update, :destroy] do
      resources :events, only: [:create, :show, :update, :destroy]
    end
    resources :quizzes, only: [:index, :show, :create, :update, :destroy] do
      resources :questions, only: [:create, :show, :update, :destroy]
    end
    resources :products, only: [:index, :show, :create]
  end
end
