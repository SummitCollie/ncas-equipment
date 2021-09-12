# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
    }

  namespace :admin do
    resources :search, only: :index
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

  authenticated :user do
    root 'dashboards#index', as: 'dashboards'
  end
  root to: redirect('/users/sign_in')

  get 'tags/search'

  get 'barcodes/start_scanner/:token', to: 'barcodes#start_scanner', as: 'start_barcode_scanner'
  get 'barcodes/send_telegram_link', to: 'barcodes#send_telegram_link'
  get 'barcodes/scanner'

  post 'webhooks/telegram/:token', to: 'webhooks#telegram', as: 'telegram_webhook'

  resources :assets, only: [:index] do
    collection do
      post 'search'
      post 'global_search'
    end
  end
end
