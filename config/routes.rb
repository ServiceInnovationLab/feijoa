# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :admin_users
    resources :birth_records

    # Administrate default page
    root to: 'birth_records#index'
  end

  devise_for :users, path: 'user', controllers: {
    # we need to override the sessions and registrations controller, others can be default
    sessions: 'user/sessions',
    registrations: 'user/registrations'
  }

  # Devise will automatically redirect to user_root_path after user login
  get 'user', to: 'user/birth_records#index', as: :user_root

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
    resources :shares
  end

  devise_for :admin_user, path: 'admin_user', controllers: {
    # we need to override the sessions and registrations controller, others can be default
    sessions: 'admin_user/sessions',
    registrations: 'admin_user/registrations'
  }

  # Devise will automatically redirect to admin_user_root_path after admin_user
  # login
  #
  # Note in this case admin/birth_records#index is the same value as admin_root
  # from the Administrate gem routes.
  get 'admin_user', to: 'admin/birth_records#index', as: :admin_user_root

  devise_for :organisation_users, path: 'organisation_user', controllers: {
    # we need to override the sessions and registrations controller, others can be default
    sessions: 'organisation_user/sessions',
    registrations: 'organisation_user/registrations'
  }

  # Devise will automatically redirect to organisation_user_root_path after organisation_user login
  get 'organisation_user', to: 'organisation_user/shares#index', as: :organisation_user_root

  namespace :organisation_user do
    resources :shares, only: %i[index show]
  end

  root to: 'home#index'
end
# rubocop:enable Metrics/BlockLength
