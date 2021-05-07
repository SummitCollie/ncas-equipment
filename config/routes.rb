# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  namespace :admin do
    resources :users do
      member do
        get :link_telegram_url
      end
    end
    resources :assets
    resources :tags, only: [:index, :update, :destroy]
    resources :checkouts
    resources :checkins
    resources :events
    resources :locations

    root to: 'users#index'
  end

  root 'dashboards#index'

  get 'tags/search'
  post 'webhooks/telegram/:token', to: 'webhooks#telegram', as: 'telegram_webhook'

  resources :assets, only: [:index]
end
