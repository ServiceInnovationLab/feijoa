# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  skip_before_action :redirect_authenticated_users, only: [:create, :destroy]
end
