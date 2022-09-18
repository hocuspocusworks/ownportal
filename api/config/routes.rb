Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    get 'explores/search'
    resources :users, :sources, :groups, :streams, :sessions
    resources :favourites

    namespace :admin do
      resources :sources
    end
  end
end
