Rails.application.routes.draw do
  devise_for :admins, path: 'admins', controllers: {
    sessions: 'admins/auth/sessions',
    registrations: 'admins/authregistrations',
    passwords: 'admins/authpasswords'
  }
  
  devise_for :tutors, path: 'tutors', controllers: {
    sessions: 'tutors/auth/sessions',
    registrations: 'tutors/auth/registrations',
    passwords: 'tutors/auth/passwords'
  }

  devise_for :users, path: 'users', controllers: {
    sessions: 'users/auth/sessions',
    registrations: 'users/auth/registrations',
    passwords: 'users/auth/passwords'
  }

  namespace :admins do
    resources :homeworks, as: :collection
  end
end
