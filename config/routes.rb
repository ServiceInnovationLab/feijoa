# frozen_string_literal: true

Rails.application.routes.draw do

  get '/user', to: 'user/home#index'
  get '/admin', to: 'admin/home#index'

  devise_for :users, path: 'users', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'user/sessions'
  }

  authenticated :user do
    root 'home#index', as: :user_root
  end

  devise_for :admins, path: 'admins', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'admin/sessions'
  }

  authenticated :admin do
    root 'home#index', as: :admin_root
  end

  root to: 'home#index'
end
