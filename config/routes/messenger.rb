namespace :messenger do
  resources :users, only: :show, param: :facebook_uuid
end