# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, path: 'users', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'user/sessions'
  }

  devise_for :admins, path: 'admins', controllers: {
    # we need to override the sessions controller, others can be default
    sessions: 'admin/sessions'
  }
end
