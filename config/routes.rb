Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # User routes
  post "/users" => "users#create"
  get "/users" => "users#index"
  get "/users/:id" => "users#show", as: :user
  put "/users/:id" => "users#update"
  delete "/users/:id" => "users#destroy"

  # Accounts routes
  post "/accounts" => "accounts#create"
  get "/accounts" => "accounts#index"
  get "/accounts/:id" => "accounts#show", as: :account
  get "/accounts/:account/account" => "accounts#getByAccountNumber"
  get "/accounts/user/:user" => "accounts#getByUserId"
  get "/accounts/:id/balance" => "accounts#getBalance"
  put "/accounts/:id" => "accounts#update"
  delete "/accounts/:id" => "accounts#destroy"

  # Address routes
  post "/address" => "address#create"
  get "/address" => "address#index"
  get "/address/:id" => "address#show"
  put "/address/:id" => "address#update"
  delete "/address/:id" => "address#destroy"
  get "/cep/:cep" => "address#search_cep"

  # Tranfer routes
  post "/transfer" => "transfer#create"
  get "/transfer" => "transfer#index"
  get "/transfer/:id" => "transfer#show"

  # Auth routes
  post "/login" => "login#login"
end
