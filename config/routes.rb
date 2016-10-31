Rails.application.routes.draw do
  root 'static_pages#index'
  get     'terms',    to: 'static_pages#terms'
  get     'privacy',  to: 'static_pages#terms'
  get     'about',    to: 'static_pages#about'

  get     'signup',   to: 'users#new'

  get     'login',    to: 'sessions#new'
  post    'login',    to: 'sessions#create'
  delete  'logout',   to: 'sessions#destroy'

  get     'onboarding/about'
  patch   'onboarding/about', to: 'onboarding#update_about'
  get     'onboarding/photo'
  post    'onboarding/photo', to: 'onboarding#create_photo'
  patch   'onboarding/photo-visibility/:visibility', to: 'onboarding#update_photo_visibility'

  get 'likes-me', to: 'likes#likers'
  get 'i-like', to: 'likes#liked'
  get 'mutual-likes', to: 'likes#mutual'

  resource :search, only: :show, controller: :search

  resources :conversations, only: :show
  resources :photos, only: [:index, :create, :destroy] do
    patch 'make-profile-photo', on: :member
  end

  resource :me, controller: :me, only: [:show, :update]
  resource :profile, controller: :profile, only: [:update]
  resource :settings, only: [] do
    get 'profile'
    get 'about'
    get 'preferences'
  end

  resources :messages, only: :index do
    get 'sent', on: :collection
  end

  get 'users', to: redirect('/search', status: 301)
  resources :users, only: [:show, :create, :new] do
    resources :messages, only: [:create]
    post 'like', on: :member
    delete 'like', to: 'users#unlike', on: :member
  end
end
