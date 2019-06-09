# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :admin_users

      root to: "users#index"
    end

  devise_for :users, path: 'user', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'user/sessions'
  }

  resources :user, only: [:index]

  devise_for :admin_user, path: 'admin_user', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'admin_user/sessions'
  }

  resources :admin_user, only: [:index]

  root to: 'home#index'
end
