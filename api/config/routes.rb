require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount Sidekiq::Web => '/sidekiq'

  get :registrations, to: 'registrations#confirm'

  namespace :api do
    get 'explores/search'
    get 'explores/rss'
    get 'explores/top'
    resources :users do
      collection do
        get :all_users
      end
    end
    resources :articles
    resources :sources
    resources :groups
    resources :streams
    resources :sessions
    resources :favourites
    resources :highlights
    resources :spaces
    resources :blogs
    resources :notifications
    resources :histories
    match 'notification/count' => 'notifications#count', via: :get
    match 'notification/read' => 'notifications#read', via: :post

    namespace :admin do
      resources :sources, :categories
      resources :stats, only: [:index]
    end
  end
end
