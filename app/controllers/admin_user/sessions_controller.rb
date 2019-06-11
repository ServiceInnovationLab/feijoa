# frozen_string_literal: true

class AdminUser::SessionsController < Devise::SessionsController
  skip_before_action :redirect_authenticated_users, only: [:create, :destroy]
end
