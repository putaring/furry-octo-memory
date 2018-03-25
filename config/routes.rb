Rails.application.routes.draw do
  root 'static_pages#index'
  get     'terms',    to: 'static_pages#terms'
  get     'privacy',  to: 'static_pages#privacy'
  get     'about',    to: 'static_pages#about'

  get     'signup',   to: 'users#new'

  get     'login',    to: 'sessions#new'
  post    'login',    to: 'sessions#create'
  delete  'logout',   to: 'sessions#destroy'

  get 'onboarding', to: 'onboarding#index'

  get 'likes-me',     to: 'likes#likers'
  get 'i-like',       to: 'likes#liked'
  get 'mutual-likes', to: 'likes#mutual'
  get 'activate',     to: 'me#activate'
  get 'banned',       to: 'me#banned'
  get 'verify',       to: 'me#verify'
  patch 'activate',   to: 'me#reactivate'
  patch 'deactivate', to: 'me#deactivate'

  resource :search, only: :show, controller: :search

  resources :conversations, only: :show
  resources :photos

  resources :favorites, only: [:index]
  resources :reports, only: [:show, :create]


  resources :phone_verifications, only: :create do
    post 'verify', on: :member
    post 'resend', on: :member
  end

  resource :me, controller: :me, only: [:show, :update]
  resource :profile, controller: :profile, only: [:update, :edit]

  resource :settings, only: [] do
    get 'account'
  end

  resources :messages, only: :index do
    get 'sent', on: :collection
  end


  get 'forgot-password', to: 'forgot_password#index'
  post 'forgot-password', to: 'forgot_password#send_instructions'

  get 'check-your-email', to: 'forgot_password#check_email'

  get 'reset-password/:reset_token', to: 'forgot_password#reset_password', as: :reset_password
  patch 'reset-password/:reset_token', to: 'forgot_password#change_password'

  get 'users', to: redirect('/search', status: 301)
  resources :users, only: [:show, :create, :new] do
    resources :messages, only: [:create]
    post 'like', on: :member
    delete 'like', to: 'users#unlike', on: :member
    post 'favorite', on: :member
    delete 'favorite', to: 'users#unfavorite', on: :member
    delete 'decline', to: 'users#decline', on: :member
  end

  namespace :admin do
    root 'admin#index'
    resources :reports, except: :destroy
    resources :users, only: :show do
      patch :ban
      patch :activate
    end
  end

  mount Shrine.presign_endpoint(:cache) => "/presign"
end
