# frozen_string_literal: true

class User::BaseController < ApplicationController
  # Only Users can access user controller actions
  before_action :authenticate_user!

  # Authenticated users are allowed to view User pages
  # This removes the deny-by-default added to ApplicationController
  # rubocop:disable Rails/LexicallyScopedActionFilter
  skip_before_action :redirect_authenticated_users
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
