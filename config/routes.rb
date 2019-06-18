# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
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
    resources :shares, only: %i[index show new create]
  end

  authenticated :user do
    root 'user#index', as: :authenticated_user_root
  end

  devise_for :admin_user, path: 'admin_user', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'admin_user/sessions'
  }

  resources :admin_user, only: [:index]

  authenticated :admin_user do
    root 'admin_user#index', as: :authenticated_admin_user_root
  end

  devise_for :organisation_users, path: 'organisation_user', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'organisation_user/sessions'
  }

  resources :organisation_user, only: [:index]

  authenticated :organisation_user do
    root 'organisation_user#index', as: :authenticated_organisation_user_root
  end

  root to: 'home#index'
end
# rubocop:enable Metrics/BlockLength
