# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, path: 'users', controllers: {
    sessions: 'users/sessions'
  }
  # authenticated_user_root to: 'user#index'

  devise_for :admins, path: 'admins', controllers: {
    sessions: 'admins/sessions'
  }
  # authenticated_admin_root to: 'admin#index'
end
