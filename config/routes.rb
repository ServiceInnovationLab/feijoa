# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, path: 'users', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'user/sessions'
  }

  authenticated :user do
    resources :user, only: [:index]
  end

  devise_for :admins, path: 'admins', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'admin/sessions'
  }

  authenticated :admin do
    resources :admin, only: [:index]
  end

  root to: 'home#index'
end
