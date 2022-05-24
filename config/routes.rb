Rails.application.routes.draw do
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

  namespace :admins do
    resources :homeworks, as: :collection
  end

  namespace :managers do
    resources :homeworks, as: :collection
  end

  namespace :tutors do
    resources :homeworks, as: :collection
  end

  namespace :users do 
    resources :homeworks, as: :collection
  end

  namespace :accountants do 
    resources :homeworks, as: :collection
  end

end
