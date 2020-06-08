namespace :messenger do
  post 'authenticate', to: 'authentication#authenticate'
  resources :users, only: :show, param: :facebook_uuid
end