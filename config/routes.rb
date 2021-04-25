# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  namespace :admin do
    resources :users
    resources :assets
    resources :tags, only: [:index, :update, :destroy]
    resources :events
    resources :locations
    resources :orders

    root to: 'users#index'
  end

  root 'dashboards#index'

  get 'tags/search'

  resources :assets, only: [:index]
end
