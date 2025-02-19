Rails.application.routes.draw do
  root "home#index"
  resource :session
  resource :admin_session
  resources :passwords, param: :token
  # 【Admin用】管理者用の管理パネル
  namespace :admin do
    resources :brands do
      resources :products, only: [:new, :create]
    end

    resources :products, except: [:new, :create] do
      resources :product_tags, except: [:index, :show]
      collection do
        get "upload"
        post "process_upload"
      end
    end
    resources :tags
  end

  # 【公開用】一般向け商品一覧・詳細ページ
  resources :brands, only: [:index, :show]
  resources :products, only: [:index, :show] 
  resources :tags, only: [:index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
