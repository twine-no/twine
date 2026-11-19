Rails.application.routes.draw do
  # A page with its own domain is served from the root of that domain
  constraints(CustomDomainConstraint.new) do
    root to: "public/pages#show", as: :custom_domain_root
  end

  root "welcome#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :registration, only: [ :new, :create ]
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]

  resource :page, only: [ :new, :create, :edit, :update ]
  namespace :links do
    resource :order, only: [ :update ]
  end
  resources :links, only: [ :create, :update, :destroy ]

  get "@:handle", to: "public/pages#show", constraints: { handle: /[^\/]+/ }, as: :public_page
  # Pages used to live under /p/, and a few of those addresses are still out there
  get "p/:handle", to: redirect("/@%{handle}")
end
