Rails.application.routes.draw do
  resources :lists do
    resources :items, only: [:create, :update]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "lists#index"
end
