Rails.application.routes.draw do
  root 'static_pages#index'

  get     'signup', to: 'users#new'

  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  get     'onboarding/about'
  patch   'onboarding/about', to: 'onboarding#update_about'
  get     'onboarding/photo'
  post    'onboarding/photo', to: 'onboarding#create_photo'
  patch   'onboarding/photo-visibility/:visibility', to: 'onboarding#update_photo_visibility'

  resource :me, controller: :me, only: [:show, :edit, :update]

  resources :users, only: [:show, :create, :new]
end
