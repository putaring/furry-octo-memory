Rails.application.routes.draw do
  root 'static_pages#index'

  get     'signup', to: 'users#new'

  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  get     'onboarding/about'
  patch   'onboarding/about', to: 'onboarding#update_about'
  get     'onboarding/photo'
  patch   'onboarding/photo', to: 'onboarding#update_photo'

  resource :me, controller: :me, only: [:show, :edit, :update]

  resources :users, only: [:show, :create, :new]
end
