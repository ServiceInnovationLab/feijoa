# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  resources :organisations, only: [:index]

  namespace :admin do
    resources :users
    resources :admin_users
    resources :birth_records
    resources :shares
    resources :organisations
    resources :organisation_members

    root to: 'birth_records#index'
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
    resources :shares, only: %i[index show new create] do
      member do
        post :revoke
      end
    end
    resources :requests, only: %i[index show]
    resources :audits, only: :index
    resources :organisations, except: %i[new create]
  end

  scope 'organisation_member/:organisation_id', as: 'organisation_member' do
    get 'dashboard', controller: 'organisation_member/dashboard', action: 'index'
    resources :shares, only: %i[index show], controller: 'organisation_member/shares'
    resources :requests, only: %i[index show new create], controller: 'organisation_member/requests'
  end

  authenticated :user do
    root 'user/dashboard#index', as: :authenticated_user_root
  end

  devise_for :admin_user, path: 'admin_user', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'admin_user/sessions'
  }

  resources :admin_user, only: [:index]

  authenticated :admin_user do
    root 'admin_user#index', as: :authenticated_admin_user_root
  end

  devise_scope :user do
    root to: 'user/sessions#new'
  end
end
# rubocop:enable Metrics/BlockLength
