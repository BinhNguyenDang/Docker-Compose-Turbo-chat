Rails.application.routes.draw do
  get 'users/show'
  # Define resources for rooms and nested resources for messages
  resources :rooms do 
    resources :messages
  end
  
  # Define the root path route to point to the 'home' action of the 'pages' controller
  root 'pages#home'
  
  # Define routes for Devise authentication
  devise_for :users
  
  # Define a route for users to access the sign-in page
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
  end
  
  # Define a route for accessing user profiles
  get 'user/:id', to: 'users#show', as: 'user'
  
  # Route to reveal the health status of the application
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Defines the root path route ("/")
  # root "posts#index"
end
