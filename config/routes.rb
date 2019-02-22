Rails.application.routes.draw do
    namespace :v1, defaults: { format: :json } do
      namespace :budweiser do
        scope module: :users do
          resources :users, only: [:index, :show, :create, :update], param: :facebook_uuid do
            resources :picks, only: [:index, :show, :create, :update]
            resources :slates, only: [:index, :show]
            get 'send_slate_confirmation', to: 'users#send_slate_confirmation'
          end
        end
        resources :slates, only: [:index, :show]
        resources :cards, only: [:create]
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
