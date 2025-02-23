Rails.application.routes.draw do
  root "welcome#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session, except: [ :show, :edit ]
  resource :registration, only: [ :new, :create ]
  resources :passwords, param: :token

  # Render dynamic PWA files from app/views/pwa/*
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # The route that ensures all your website can be hosted on twine.no/@mypage
  get "@:shortname", to: "public/platforms#show", constraints: { shortname: /[^\/]+/ }, as: :public_site
  get "p/:shortname", to: "public/platforms#show", as: :legacy_public_site

  get "e/:guid", to: "public/meetings#show", constraints: { guid: /[^\/]+/ }, as: :public_event
  resources :events, only: [ :show ], controller: :meetings

  namespace :admin do
    resource :onboarding, only: [ :show, :update ]
    resource :dashboard, only: [ :show ]
    resources :memberships, path: "members"
    resources :groups, only: [ :new, :create, :edit, :update, :destroy ]
    resources :groups_memberships, only: [ :create, :destroy ]
    resources :links, only: [ :new, :create, :update, :destroy ] do
      collection do
        patch :sort
      end
    end
    resource :site, only: [ :show, :update ]
    resources :meetings do
      resources :invites, only: [ :create, :index, :show, :destroy ]
      resources :mass_invites, only: [ :create ]
      resources :rsvps, only: [ :create, :update ]
      resources :resend_confirmations, only: [ :create ]
      resource :surveys, only: [ :new, :create, :edit, :update ]
      resource :share, only: [ :show, :update ]
    end

    namespace :messages do
      resources :meeting_invites, only: [ :new, :create ]
    end
  end

  namespace :public do
    resources :rsvps, only: [ :new, :create, :edit, :update ]
  end

  namespace :member do
    resource :dashboard, only: [ :show ]
  end
end
