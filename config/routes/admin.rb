# api.playsweep.com/v2/admin

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
  resources :users, only: [:index, :show, :update, :destroy]
end