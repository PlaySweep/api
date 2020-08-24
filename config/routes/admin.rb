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
  resources :templates, only: [:index, :show]
  post 'templates/build', to: 'templates#build'
  resources :users, only: [:index, :show, :update, :destroy]
  get 'leaderboard_csv_mailer', to: 'data_analytic_controller#leaderboard_csv_mailer'
  get 'fetch_selections_mailer', to: 'data_analytic_controller#fetch_selections_mailer'
  get 'fetch_orders_mailer', to: 'data_analytic_controller#fetch_orders_mailer'
  get 'fetch_skus_mailer', to: 'data_analytic_controller#fetch_skus_mailer'
  get 'fetch_teams_mailer', to: 'data_analytic_controller#fetch_teams_mailer'
  get 'fetch_products_mailer', to: 'data_analytic_controller#fetch_products_mailer'
  get 'fetch_users_mailer', to: 'data_analytic_controller#fetch_users_mailer'
end