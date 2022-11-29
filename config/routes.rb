Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #
  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root to: "home#index"
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      resources :users
      resources :home
    end
  end

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'clients/sessions', registrations: 'clients/registrations' }
    namespace :clients, path: '' do
      root to: "home#index"
      resources :home
      resources :profile
    end
  end
end