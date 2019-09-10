# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  resources :organisations, only: [:index]

  devise_for :users, path: 'user'

  namespace :user do
    resources :dashboard, only: %i[index]
    get 'documents/:type/:id', to: 'documents#show', as: :document
    post 'documents/:type/:id/remove', to: 'documents#remove', as: :document_remove
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
    resources :immunisation_records, only: %i[update new create]
    resources :shares, only: %i[index show new create] do
      member do
        post :revoke
      end
    end
    resources :requests, only: %i[index show] do
      member do
        post :decline
        post :respond
      end
    end
    resources :audits, only: :index
    resources :organisations, only: [] do
      collection { get 'autocomplete' }
    end
  end

  scope 'organisation_member/:organisation_id', as: 'organisation_member' do
    get 'dashboard', controller: 'organisation_member/dashboard', action: 'index'
    resources :shares, only: %i[index show], controller: 'organisation_member/shares'
    resources :requests, only: %i[index show new create], controller: 'organisation_member/requests' do
      member do
        post :cancel
      end
    end
  end

  authenticated :user do
    root 'user/dashboard#index', as: :authenticated_user_root
  end

  devise_scope :user do
    root to: 'devise/sessions#new'
  end
end
# rubocop:enable Metrics/BlockLength
