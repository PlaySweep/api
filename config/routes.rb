Rails.application.routes.draw do
  mount Resque::Server.new, at: '/resque'
  namespace :v1, defaults: { format: :json } do
    namespace :budweiser do
        resources :users, only: [:index, :show, :create, :update], param: :facebook_uuid do
          scope module: :users do
            resources :picks, only: [:index, :show, :create, :update]
            resources :slates, only: [:index, :show]
            resources :preferences, only: [:show, :update]
          end
      end
      resources :slates, only: [:index, :show]
      resources :cards, only: [:create]
      resources :preferences, only: [:index, :show] do
        member do
          get 'set_owner', to: 'preferences#set_owner'
        end
      end
      get 'fetch_card_for_slate', to: 'cards#fetch_card_for_slate'
    end
  end
  
  namespace :admin, defaults: { format: :json } do
    resources :leagues, only: [:index]
    resources :teams, only: [:index, :show] do
      resources :slates, only: [:index, :show, :create, :update, :destroy] do
        resources :events, only: [:create, :show, :update]
      end
    end
  end
end
