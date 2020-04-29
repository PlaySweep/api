# api.playsweep.com/v2/admin/leagues

namespace :admin, defaults: { format: :json } do
  resources :leagues, only: [:index]
  resources :teams, only: [:index, :show]
  resources :slates, only: [:index, :show, :create, :update, :destroy] do
    resources :events, only: [:create, :show, :update, :destroy]
  end
  resources :products, only: [:index, :show, :create]
end