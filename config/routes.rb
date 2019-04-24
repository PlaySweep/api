Rails.application.routes.draw do
  mount Resque::Server.new, at: '/resque'
  namespace :v1, defaults: { format: :json } do
    namespace :budweiser do
        resources :users, only: [:index, :show, :create, :update], param: :facebook_uuid do
          scope module: :users do
            resources :picks, only: [:index, :show, :create, :update]
            resources :slates, only: [:index, :show]
          end
      end
      resources :slates, only: [:index, :show]
      resources :cards, only: [:create]
      resources :entries, only: [:create]
      get 'fetch_card_for_slate', to: 'cards#fetch_card_for_slate'
    end

    namespace :turner do
        resources :users, only: [:index, :show, :create, :update], param: :facebook_uuid do
          scope module: :users do
            resources :picks, only: [:index, :show, :create, :update]
            resources :slates, only: [:index, :show]
          end
      end
      resources :slates, only: [:index, :show]
      resources :cards, only: [:create]
      resources :entries, only: [:create]
      get 'fetch_card_for_slate', to: 'cards#fetch_card_for_slate'
    end
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
