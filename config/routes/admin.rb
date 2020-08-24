# api.sweepapp.io/v2/admin
# Use single quotes in routing

namespace :admin, defaults: { format: :json } do
  post 'authenticate', to: 'authentication#authenticate'
  resources :slates, only: [:show, :update, :destroy] do
    resources :events, only: [:show, :update, :destroy]
  end
  resources :events, only: [:show, :update, :destroy]
  resources :picks, only: [:update]
  resources :teams, only: [:index]
  resources :products, only: [:index, :show, :create]
  resources :players, only: [:index, :show, :create]
  resources :prizes, only: [:index, :show, :create]
  resources :selections, only: [:update]
  resources :skus, only: [:index, :show]
  resources :slates, only: [:index, :show, :update]
  resources :standings, only: [:index, :show, :update]
  resources :templates, only: [:index, :show]
  post 'templates/build', to: 'templates#build'
  resources :users, only: [:index, :show, :update, :destroy]
  get 'data/fetch_orders', to: 'data#fetch_orders'
  get 'data/fetch_player_activity', to: 'data#fetch_player_activity'
end

