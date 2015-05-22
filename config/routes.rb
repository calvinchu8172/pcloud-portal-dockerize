
Rails.application.routes.draw do

  namespace :api do
  namespace :user do
    get 'register/create'
    end
  end

  # get '*unmatched_route', :to => 'application#raise_not_found!'

  # get "/404", :to => 'application#raise_not_found!'

  constraints :host => Settings.environments.portal_domain do
    devise_scope :user do
      # setting root path to personal index page, if user signed in
      authenticated :user do
        root 'personal#index', as: :authenticated_root
      end

      # setting root path to sign in page, if user not sign in
      unauthenticated do
        root 'devise/sessions#new', as: :unauthenticated_root
      end
    end

    get 'hint/signup'
    get 'hint/confirm'
    get 'hint/reset'
    get 'hint/sent'
    get 'hint/agreement'

    resources :ddns
    post 'ddns/check'
    post 'discoverer/search'

    get 'registrations/success'

    devise_for :users, :controllers => {
      :registrations => "registrations",
      :confirmations => 'confirmations',
      :sessions => "sessions",
      :passwords => 'passwords',
      :omniauth_callbacks => "users/omniauth_callbacks"}

    get 'device/register'

    unless Rails.env.production?
      mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    end

    resources :upnp

    get 'upnp/check/:id' , to: 'upnp#check'
    get '/:controller(/:action(/:id))(.format)'
    post 'oauth/confirm'

  end

  constraints :host => Settings.environments.api_domain  do

    post '/d/1/:action' => "device"
    post '/d/2/:action' => "device"

    scope :path => '/user/1/', :module => "api/user" do
      # match ':controller(/:action(/:id(.:format)))', :via => :all
      resource :tokens, format: 'json'
      resource :register, format: 'json'
      get 'checkin/:oauth_provider', to: 'oauth#mobile_checkin', format: 'json'
      post 'register/:oauth_provider', to: 'oauth#mobile_register', format: 'json'
    end

    scope :path => '/resource/1/', :module => "api/resource" do
      delete 'permission', to: 'permissions#delete', format:'json'

      get 'invitation', to: 'invitations#index', format: 'json'
      post 'invitation', to: 'invitations#create', format: 'json'

      get 'device_list' => "personal#device_list", format: 'json'
    end

    root "application#raise_not_found!", via: :all
  end

  get "*path", to: "application#raise_not_found!", via: :all

end
