Rails.application.routes.draw do
  root "welcome#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session, except: [:show, :edit]
  resource :registration, only: [:new, :create]
  resources :passwords, param: :token

  # Render dynamic PWA files from app/views/pwa/*
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :admin do
    resource :onboarding, only: [:show, :update]
    resource :dashboard, only: [:show]
    resources :memberships, path: "members"
    resources :groups, only: [:new, :create, :edit, :update, :destroy]
    resources :groups_memberships, only: [:create, :destroy]
    resources :links, only: [:new, :create, :update, :destroy]
    resource :site, only: [:show, :update]
    resources :meetings do
      resources :invites, only: [:create, :index, :destroy]
      resources :mass_invites, only: [:create]
      resources :surveys, only: [:new, :create, :index, :edit, :update]
      resources :meeting_previews, only: [:index]
    end

    namespace :messages do
      resources :meeting_invites, only: [:new, :create]
    end
  end

  get "p/:shortname", to: "public/platforms#show", as: :public_site

  namespace :public do
    resources :events, only: [:show], controller: :meetings
    resources :rsvps, only: [:new, :create, :edit, :update]
  end

  namespace :member do
    resource :dashboard, only: [:show]
  end
end
