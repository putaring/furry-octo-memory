Rails.application.routes.draw do
  root 'static_pages#index'

  get     'signup', to: 'users#new'

  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  get     'onboarding/about'
  get     'onboarding/photo'

  resource :me, controller: :me, only: [:show, :edit, :update]

  resources :users, only: [:show, :create, :new]
end
