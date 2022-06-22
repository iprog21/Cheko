Rails.application.routes.draw do
  root to: 'pages#home'
  get '/pick_type', to: 'pages#pick_type'
  get '/new', to: 'pages#new'
  get '/professors', to: 'pages#professors'
  get '/professors/:id', to: 'pages#professor_show'

  devise_for :admins, path: 'admins', controllers: {
    sessions: 'admins/auth/sessions',
    registrations: 'admins/auth/registrations',
    passwords: 'admins/auth/passwords'
  }
  
  devise_for :tutors, path: 'tutors', controllers: {
    sessions: 'tutors/auth/sessions',
    registrations: 'tutors/auth/registrations',
    passwords: 'tutors/auth/passwords'
  }

  devise_for :managers, path: 'managers', controllers: {
    sessions: 'managers/auth/sessions',
    registrations: 'managers/auth/registrations',
    passwords: 'managers/auth/passwords'
  }

  devise_for :accountants, path: 'accountants', controllers: {
    sessions: 'accountants/auth/sessions',
    registrations: 'accountants/auth/registrations',
    passwords: 'accountants/auth/passwords'
  }

  devise_for :users, path: 'users', controllers: {
    sessions: 'users/auth/sessions',
    registrations: 'users/auth/registrations',
    passwords: 'users/auth/passwords'
  }

  devise_for :quality_officers, path: 'quality_officers', controllers: {
    sessions: 'quality_officers/auth/sessions'
    # registrations: 'quality_officers/auth/registrations',
    # passwords: 'quality_officers/auth/passwords'
  }

  namespace :admins do
    resources :homeworks, except: [:new, :create], on: :collection do
      put :assign
      put :finish_homework
      put :assign_tutor
    end
    resources :professors 
    resources :prof_reviews, only: [:show, :update] do 
      post :approve
    end
    resources :documents, only: [:index], on: :collection
    resources :managers, on: :collection
    resources :users, on: :collection
    resources :tutors, on: :collection
    resources :accountants, on: :collection
    resources :admins
    resources :chats, only: [:index]
    resources :quality_officers, on: :collection
    get '/', to: 'dashboard#home'
  end
  
  namespace :quality_officers do 
    resources :homeworks, only: [:index, :show] do
      post :upload
    end
    get '/', to: 'dashboard#home'
  end

  namespace :managers do
    resources :homeworks, only: [:index, :show, :update], on: :collection
    resources :chats, only: [:index]
    get '/', to: 'dashboard#home'
  end

  namespace :tutors do
    resources :homeworks, only: [:index, :show], on: :collection do 
      get :add_bid
      get :edit_bid
      post :bid
      put :update_bid
      post :upload, on: :collection
    end
    resources :chats, only: [:index]
    get '/', to: 'dashboard#home'
  end

  namespace :users do 
    resources :homeworks, on: :collection do
      get :pick_type, on: :collection
    end

    resources :professors, only: [:index, :show, :new, :create] do
      get :search, on: :collection
    end

    get 'profile', to: 'users#show'
    resources :chats, only: [:index]
    get '/', to: 'dashboard#home'
  end

  namespace :accountants do 
    resources :homeworks, only: [:index, :show, :update], on: :collection
    get '/', to: 'dashboard#home'
  end

end
