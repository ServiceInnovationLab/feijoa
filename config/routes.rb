# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :admin_users
    resources :birth_records

    root to: 'users#index'
  end

  devise_for :users, path: 'user', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'user/sessions'
  }

  resources :user, only: [:index]
  namespace :user do
    resources :birth_records, only: %i[index show] do
      collection do
        get :find
        post :find, to: 'birth_records#query'
      end
      member do
        post :add
        post :remove
      end
    end
  end

  devise_for :admin_user, path: 'admin_user', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'admin_user/sessions'
  }

  resources :admin_user, only: [:index]

  root to: 'home#index'
end
