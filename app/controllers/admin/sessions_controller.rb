# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  # rubocop:disable Rails/LexicallyScopedActionFilter
  skip_before_action :redirect_authenticated_users, only: [:create, :destroy]
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
