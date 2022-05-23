Rails.application.routes.draw do
  devise_for :super_admins
  devise_for :admins
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
end
