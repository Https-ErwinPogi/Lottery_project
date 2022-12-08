Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #
  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root to: "home#index", as: :admin_root
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      resources :users
      resources :items do
        put :start
        put :pause
        put :end
        put :cancel
      end
      resources :categories
    end
  end

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'clients/sessions', registrations: 'clients/registrations' }
    namespace :clients, path: '' do
      root to: "home#index"
      resources :profiles
      resources :addresses
      resources :invites
    end
  end

  namespace :api do
    resources :regions, only: :index, defaults: { format: :json } do
      resources :provinces, only: :index, defaults: { format: :json } do
        resources :city_municipalities, only: :index, defaults: { format: :json } do
          resources :barangays, only: :index, defaults: { format: :json }
        end
      end
    end
  end
end