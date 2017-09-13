Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/activation", to:"accountactivation#edit"

  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'

  get "search(/:search)", to: "searches#index", as: :search

   scope '(:locale)' do
        resources :users
        resources :users do
          member do
            get :following, :followers
          end
        end
        root "static_pages#home"
   end
  
  resources :password_resets
  resources :microposts do
    resources :comments
  end
  resources :relationships, only: [:create, :destroy]
end
