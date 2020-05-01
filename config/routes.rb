require 'sidekiq/web'

Rails.application.routes.draw do

  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end

  root to: 'home#index'
  mount Sidekiq::Web => '/sidekiq'

  namespace :v2, defaults: { format: :json } do
    post 'authenticate', to: 'authentication#authenticate'
    resources :contests, :slates, :quizzes, only: [:index, :show, :update]
    resources :question_sessions, only: [:create, :update]
    resources :orders, only: [:index, :create]
    resources :achievements, :teams, only: [:index]
    resources :prizes, :questions, only: [:show]
    resources :nudges, only: [:create]
    resources :users, only: [:show, :create, :update] do
      scope module: :users do
        resources :choices, :picks, only: [:index, :show, :create, :update]
        resources :cards, only: [:index, :create, :update]
        resources :addresses, :phone_numbers, only: [:show, :create, :update]
        resources :user_elements, only: [:index, :update]
        resources :slates, :quizzes, only: [:index]
        resources :roles, only: [:create]
      end
    end
    draw :messenger
    draw :messaging
    draw :admin
  end
end
