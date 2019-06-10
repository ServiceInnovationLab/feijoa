# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'user', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'user/sessions'
  }

  resources :user, only: [:index]

  devise_for :admins, path: 'admin', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'admin/sessions'
  }

  resources :admin, only: [:index]

  root to: 'home#index'
end
