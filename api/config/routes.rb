Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    get 'explores/search'
    get 'explores/rss'
    resources :users do
      collection do
        get :all_users
      end
    end
    resources :sources
    resources :groups
    resources :streams
    resources :sessions
    resources :favourites
    resources :highlights

    namespace :admin do
      resources :sources, :categories
      resources :stats, only: [:index]
    end
  end
end
